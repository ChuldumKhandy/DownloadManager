import Foundation

protocol ISettingsPresenter {
    func loadView(controller: SettingsViewController, viewScene: ISettingsView, navigation: ISettingsNavigation)
}

final class SettingsPresenter {
    private weak var controller: ISettingsViewController?
    private weak var viewScene: ISettingsView?
    private weak var navigation: ISettingsNavigation?
    private let router: ISettingsRouter
    
    init(router: SettingsRouter) {
        self.router = router
    }
}

extension SettingsPresenter: ISettingsPresenter {
    func loadView(controller: SettingsViewController, viewScene: ISettingsView, navigation: ISettingsNavigation) {
        self.controller = controller
        self.viewScene = viewScene
        self.navigation = navigation
        self.onTouched()
    }
}

private extension SettingsPresenter {
    func onTouched() {
        self.saveUserSettings()
        self.backToDownloadListScene()
    }
    
    func saveUserSettings() {
        self.viewScene?.saveSettings = { [weak self] maxSegmentSize, numberOfSegments, numberOfFiles, numberOfAttemptsReconnect in
            guard let maxSegmentSize = maxSegmentSize,
                  maxSegmentSize.isEmpty == false else {
                self?.controller?.showAlert(title: "Внимание", message: "Введите данные")
                return
            }
            guard let segmentSize = Int64(maxSegmentSize) else {
                self?.controller?.showAlert(title: "Внимание", message: "Введите корректные данные")
                return
            }
            let settings = UserSettings(maxSegmentSize: segmentSize,
                                        maxNumberOfSegments: self?.isEmptyStringToInt(numberOfSegments),
                                        maxNumberOfFiles: self?.isEmptyStringToInt(numberOfFiles),
                                        numberOfAttemptsReconnect: self?.isEmptyStringToInt(numberOfAttemptsReconnect))
            UserSettingsStorage.shared.userSettings = settings
            self?.controller?.showAlert(title: "Внимание", message: "Настройки успешно сохранены")
        }
    }
    
    func backToDownloadListScene() {
        self.navigation?.backVCHandler = { [weak self] in
            self?.router.backVC()
        }
    }
    
    func isEmptyStringToInt(_ string: String?) -> Int? {
        if let string = string {
            return Int(string)
        }
        return nil
    }
}

