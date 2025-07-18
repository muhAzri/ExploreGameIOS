import Foundation

struct APIConstants {
    static let baseURL = Configuration.shared.baseURL
    static let apiKey = Configuration.shared.apiKey
    
    struct Endpoints {
        static let games = "/games"
        static func gameDetail(id: Int) -> String {
            return "/games/\(id)"
        }
    }
}

struct AppConstants {
    static let defaultPageSize = 20
    static let searchDebounceTime = 0.5
}