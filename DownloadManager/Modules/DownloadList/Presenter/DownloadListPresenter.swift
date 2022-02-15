import Foundation

protocol IDownloadListPresenter {
    func loadView(controller: DownloadListViewController, viewScene: IDownloadListView, navigation: IDownloadListNavigation)
}

final class DownloadListPresenter {
    private weak var controller: IDownloadListViewController?
    private weak var viewScene: IDownloadListView?
    private weak var navigation: IDownloadListNavigation?
    private var networkService: INetworkService
    private var files = [FileModel]()
    private let router: IDownloadListRouter
    private let segmentSize: Float = 1024
    private let totalActiveSegments = 5
    
    init(router: DownloadListRouter, networkService: NetworkService) {
        self.networkService = networkService
        self.router = router
    }
}

extension DownloadListPresenter: IDownloadListPresenter {
    func loadView(controller: DownloadListViewController, viewScene: IDownloadListView, navigation: IDownloadListNavigation) {
        self.controller = controller
        self.viewScene = viewScene
        self.navigation = navigation
        self.onTouched()
    }
}

private extension DownloadListPresenter {
    func onTouched() {
        self.downloadTapped()
        self.showAlertFailure()
        self.completionDownloadTask()
        self.pauseTapped()
        self.resumeTapped()
        self.openSettingScene()
    }
    
    func downloadTapped() {
        self.viewScene?.getUrlHandler = { [weak self] urlString in
            guard let url = urlString else {
                return
            }
            self?.networkService.startDownload(url: url)
        }
    }
    
    func showAlertFailure() {
        self.networkService.completionFailure = { [weak self] error in
            print("[NETWORK] error is: \(error)")
            DispatchQueue.main.async {
                self?.controller?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    func completionDownloadTask() {
        self.networkService.completionDownloadTaskInfoUpdate = { [weak self] downloadsList in
            self?.files = downloadsList.map { taskInfo -> FileModel in
                let progressString = String(format: "Total downloaded: \(taskInfo.currentSegment) / \(taskInfo.totalSegment)")
                
                return FileModel(id: taskInfo.id,
                            name: taskInfo.name,
                            url: taskInfo.url,
                            savedURL: taskInfo.savedURL,
                            progressString: progressString,
                            progress: taskInfo.progress,
                            downloadIsOver: taskInfo.downloadIsOver)
            }
            DispatchQueue.main.async {
                self?.viewScene?.getData(data: self?.files ?? [])
            }
        }
    }
    
    func pauseTapped() {
        self.viewScene?.didPressPauseButtonAtHandler = { [weak self] index in
            if let url = self?.files[index].url {
                self?.networkService.pauseDownload(url: url)
            }
        }
    }
    
    func resumeTapped() {
        self.viewScene?.didPressResumeButtonAtHandler = { [weak self] index in
            if let url = self?.files[index].url {
                self?.networkService.resumeDownload(url: url)
            }
        }
    }

    func openSettingScene() {
        self.navigation?.openSettingsHandler = { [weak self] in
            self?.router.nextVC(controller: SettingsAssembly.build())
        }
    }
}

