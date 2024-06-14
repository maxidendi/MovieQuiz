import Foundation

enum NetworkErrors: LocalizedError {
    case codeError
    case invalidUrlError(String)
    case loadImageError(String)
    var errorDescription: String?{
        switch self{
        case .codeError:
            localizedDescription
        case .invalidUrlError(let description):
            description
        case .loadImageError(let description):
            description
        }
    }
}

