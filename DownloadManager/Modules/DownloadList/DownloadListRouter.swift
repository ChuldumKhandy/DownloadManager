import UIKit

protocol IDownloadListRouter {
    func setRootController(controller: UIViewController)
    func nextVC(controller: UIViewController)
}

final class DownloadListRouter {
    private var controller: UIViewController?
}

extension DownloadListRouter: IDownloadListRouter {
    func setRootController(controller: UIViewController) {
        self.controller = controller
    }
    func nextVC(controller: UIViewController) {
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
