import UIKit

protocol IDownloadListViewController: AnyObject {
    func showAlert(title: String, message: String)
}

final class DownloadListViewController: UIViewController {
    private let viewScene: IDownloadListView
    private let presenter: IDownloadListPresenter
    private let navigation: IDownloadListNavigation
    
    init(presenter: DownloadListPresenter) {
        self.presenter = presenter
        self.navigation = DownloadListNavigation()
        self.viewScene = DownloadListView(frame: UIScreen.main.bounds)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.presenter.loadView(controller: self, viewScene: self.viewScene, navigation: self.navigation)
        self.navigation.loadView(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addSubview(self.viewScene)
        self.viewScene.translatesAutoresizingMaskIntoConstraints = false
        self.viewScene.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.viewScene.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.viewScene.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.viewScene.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension DownloadListViewController: IDownloadListViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Понятно", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
