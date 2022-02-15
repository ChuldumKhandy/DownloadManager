import Foundation

enum NetworkError: Error {
    case badURL
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badURL:
            return "Вы ввели запрос, который не является URL"
        }
    }
}
