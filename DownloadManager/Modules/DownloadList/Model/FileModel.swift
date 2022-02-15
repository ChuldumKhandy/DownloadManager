import Foundation

struct FileModel {
    let id: UUID
    let name: String
    var url: URL
    var savedURL: URL?
    
    var progressString: String = "Нет данных"
    var progress: Float = 0
    var downloadIsOver: Bool
}
