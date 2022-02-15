import UIKit

final class SettingsAssembly {
    static func build() -> UIViewController {
        let router = SettingsRouter()
        let presenter = SettingsPresenter(router: router)
        let controller = SettingsViewController(presenter: presenter)
        router.setRootController(controller: controller)
        return controller
    }
}
