import Foundation

final class FileDTO {
    let id = UUID()
    let name: String
    var downloadTask: URLSessionDownloadTask
    var url: URL
    var savedURL: URL?
    var resumeData: Data?
    var totalBytesWritten: Int64?
    var totalBytesExpectedToWrite: Int64?
    
    var currentSegment = 0
    var totalSegment: Int64 = 0
    
    var progress: Float = 0
    var downloadIsOver = false
    
    init(name: String, url: URL, downloadTask: URLSessionDownloadTask) {
        self.name = name
        self.url = url
        self.downloadTask = downloadTask
    }
}
