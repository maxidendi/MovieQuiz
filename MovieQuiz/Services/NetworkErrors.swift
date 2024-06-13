import Foundation

enum NetworkErrors: LocalizedError {
    case codeError
    case invalidUrlError(String)
    case loadImageError(String)
    var errorDescription: String?{
        switch self{
        case .codeError:
            return localizedDescription
        case .invalidUrlError(let error):
            return error
        case .loadImageError(let error):
            return error
        }
    }
}
