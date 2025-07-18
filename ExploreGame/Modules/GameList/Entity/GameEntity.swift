import Foundation

struct GameResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Game]
}

struct Game: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let backgroundImage: String?
    let released: String?
    let rating: Double
    let metacritic: Int?
    let platforms: [PlatformInfo]?
    let genres: [Genre]?
    let esrbRating: ESRBRating?
    
    enum CodingKeys: String, CodingKey {
        case id, name, released, rating, metacritic, platforms, genres
        case backgroundImage = "background_image"
        case esrbRating = "esrb_rating"
    }
}

struct PlatformInfo: Codable, Hashable {
    let platform: Platform
}

struct Platform: Codable, Hashable {
    let id: Int
    let name: String
    let slug: String
}

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
    let slug: String
}

struct ESRBRating: Codable, Hashable {
    let id: Int
    let name: String
    let slug: String
}
