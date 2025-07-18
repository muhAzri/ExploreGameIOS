import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case httpError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL - Please check your internet connection"
        case .noData:
            return "No data received from server"
        case .decodingError:
            return "Failed to parse server response - The data format may have changed"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .httpError(let statusCode):
            switch statusCode {
            case 404:
                return "Game not found (404) - This game may no longer exist"
            case 403:
                return "Access denied (403) - API key may be invalid"
            case 500...599:
                return "Server error (\(statusCode)) - Please try again later"
            default:
                return "HTTP error (\(statusCode)) - Please try again"
            }
        }
    }
}
