import UIKit

protocol IDownloadListNavigation: UIView {
    func loadView(controller: DownloadListViewController)
    
    var openDownloadedFilesHandler: (() -> Void)? { get set }
    var openSettingsHandler: (() -> Void)? { get set }
}

final class DownloadListNavigation: UIView {
    private weak var controller: DownloadListViewController?
    
    var openDownloadedFilesHandler: (() -> Void)?
    var openSettingsHandler: (() -> Void)?
}

extension DownloadListNavigation: IDownloadListNavigation {
    func loadView(controller: DownloadListViewController) {
        self.controller = controller
        self.customizeNavigation()
    }
}

private extension DownloadListNavigation {
    func customizeNavigation() {
        self.controller?.navigationController?.navigationBar.barTintColor = .white
        self.controller?.navigationController?.navigationBar.shadowImage = UIImage()
        self.controller?.title = "Download manager"
        
        self.leftBarItem()
    }
    
    func leftBarItem() {
        let leftBarItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.openSettings))
        leftBarItem.tintColor = .black
        self.controller?.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    @objc func openSettings() {
        self.openSettingsHandler?()
    }
}
