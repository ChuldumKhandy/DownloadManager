import Foundation
import UIKit

protocol INetworkService {
    var completionFailure: ((Error) -> Void)? { get set }
    var completionDownloadTaskInfoUpdate: (([FileDTO]) -> Void)? { get set }
    
    func startDownload(url: String)
    func pauseDownload(url: URL)
    func resumeDownload(url: URL)
}

final class NetworkService: NSObject {
    private lazy var session: URLSession  = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "background")
        configuration.shouldUseExtendedBackgroundIdleMode = true
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    private var downloadTaskInfoList = [FileDTO]() {
        didSet {
            self.completionDownloadTaskInfoUpdate?(self.downloadTaskInfoList)
        }
    }
    private var activeDownloads: [URL: FileDTO] = [ : ]
    
    private var segmentSize: Int64 = 1024
    private var totalSegment: Int64 = 1
    
    var completionFailure: ((Error) -> Void)?
    var completionDownloadTaskInfoUpdate: (([FileDTO]) -> Void)?
}

extension NetworkService: INetworkService {
    func startDownload(url: String) {
        if self.canOpenURL(url) {
            guard let url = URL(string: url) else {
                self.completionFailure?(NetworkError.badURL)
                return
            }
            self.setFileSize(url: url) {
                let downloadTask = self.session.downloadTask(with: url)
                self.addDownloadTaskInfo(name: url.lastPathComponent, url: url, task: downloadTask)
                downloadTask.resume()
                self.activeDownloads[url] = self.downloadTaskInfoList.last
            }
        } else {
            self.completionFailure?(NetworkError.badURL)
        }
    }
    
    func pauseDownload(url: URL) {
        guard let download = self.activeDownloads[url] else {
            return
        }
        download.downloadTask.cancel { data in
            download.resumeData = data
        }
        download.downloadIsOver = true
    }
    
    func resumeDownload(url: URL) {
        guard let download = self.activeDownloads[url] else {
            return
        }
        if let resumeData = download.resumeData {
            download.downloadTask = self.session.downloadTask(withResumeData: resumeData)
        } else {
            download.downloadTask = self.session.downloadTask(with: download.url)
        }
        download.downloadTask.resume()
        download.downloadIsOver = false
    }
}

extension NetworkService: URLSessionDownloadDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                  let backgroundCompletionHandler = appDelegate.backgroundCompletionHandler else {
                return
            }
            backgroundCompletionHandler()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("[NETWORK]: \(#function) - Скачано полностью")
        let downloadTaskInfo = self.downloadTaskInfoList.first { downloadTask == $0.downloadTask }
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            let savedURL = documentsURL.appendingPathComponent(location.lastPathComponent)
            try FileManager.default.moveItem(at: location, to: savedURL)
            downloadTaskInfo?.savedURL = savedURL
            downloadTaskInfo?.totalBytesWritten = downloadTaskInfo?.totalBytesExpectedToWrite
            downloadTaskInfo?.downloadIsOver = true
            self.completionDownloadTaskInfoUpdate?(self.downloadTaskInfoList)
        } catch {
            self.downloadTaskInfoList.removeAll { downloadTask === $0.downloadTask }
            self.completionFailure?(error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let downloadTaskInfo = self.downloadTaskInfoList.first { downloadTask == $0.downloadTask }
        downloadTaskInfo?.totalSegment = self.totalSegment
        downloadTaskInfo?.currentSegment = Int(totalBytesWritten / self.segmentSize)
        downloadTaskInfo?.totalBytesWritten = totalBytesWritten
        downloadTaskInfo?.totalBytesExpectedToWrite = totalBytesExpectedToWrite
        downloadTaskInfo?.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        self.completionDownloadTaskInfoUpdate?(self.downloadTaskInfoList)
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error {
            self.completionFailure?(error)
        } else {
            print("[NETWORK]: \(#function) - error равно nil")
        }
    }
}

private extension NetworkService {
    func addDownloadTaskInfo(name: String, url: URL, task: URLSessionDownloadTask) {
        let downloadTaskInfo = FileDTO(name: name, url: url, downloadTask: task)
        self.downloadTaskInfoList.append(downloadTaskInfo)
    }
    
    func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string,
              let url = URL(string: urlString) else {
            return false
        }
        if !UIApplication.shared.canOpenURL(url) {
            return false
        }
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    func setFileSize(url: URL, completion: @escaping(() -> Void)) {
        let timeOutInterval = 1.0
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeOutInterval)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { data, response, error in
            let contentLength = response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
            if let error = error {
                self.completionFailure?(error)
            } else {
                self.segmentSize = UserSettingsStorage.shared.userSettings.maxSegmentSize
                self.totalSegment = (contentLength / self.segmentSize == 0) ? 1 : (contentLength / self.segmentSize)
                completion()
            }
        }.resume()
    }
}
