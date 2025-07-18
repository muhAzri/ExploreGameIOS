import Foundation

enum APIEndpoint {
    case games(search: String?, page: Int)
    case gameDetail(id: Int)
    
    var baseURL: String {
        return APIConstants.baseURL
    }
    
    var path: String {
        switch self {
        case .games:
            return "/games"
        case .gameDetail(let id):
            return "/games/\(id)"
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .games(let search, let page):
            var params = ["page": "\(page)"]
            if let search = search, !search.isEmpty {
                params["search"] = search
            }
            return params
        case .gameDetail:
            return nil
        }
    }
}