import UIKit

protocol ISettingsNavigation: UIView {
    var backVCHandler: (() -> Void)? { get set }
    
    func loadView(controller: SettingsViewController)
}

final class SettingsNavigation: UIView {
    private weak var controller: SettingsViewController?
    
    var backVCHandler: (() -> Void)?
}

extension SettingsNavigation: ISettingsNavigation {
    func loadView(controller: SettingsViewController) {
        self.controller = controller
        self.customizeNavigation()
    }
}

private extension SettingsNavigation {
    func customizeNavigation() {
        self.controller?.navigationController?.navigationBar.barTintColor = .white
        self.controller?.navigationController?.navigationBar.shadowImage = UIImage()
        self.controller?.title = "Settings"
        self.leftBarItem()
    }
    
    func leftBarItem() {
        let leftBarItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.backVC))
        leftBarItem.tintColor = .black
        self.controller?.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    @objc func backVC() {
        self.backVCHandler?()
    }
}
