import Foundation

class UserSettingsStorage: NSObject {
    static let shared = UserSettingsStorage()
    private override init() {
        super.init()
    }
    
    var userSettings = UserSettings()
}
