import UIKit

protocol ISettingsRouter {
    func setRootController(controller: UIViewController)
    func backVC()
}

final class SettingsRouter {
    private var controller: UIViewController?
}

extension SettingsRouter: ISettingsRouter {
    func setRootController(controller: UIViewController) {
        self.controller = controller
    }
    func backVC() {
        self.controller?.navigationController?.popViewController(animated: true)
    }
}
