import UIKit

final class DownloadListAssembly {
    static func build() -> UIViewController {
        let router = DownloadListRouter()
        let networkService = NetworkService()
        let presenter = DownloadListPresenter(router: router, networkService: networkService)
        let controller = DownloadListViewController(presenter: presenter)
        router.setRootController(controller: controller)
        return controller
    }
}
