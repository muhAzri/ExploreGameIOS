import Foundation

struct GameDetail: Codable {
    let id: Int
    let name: String
    let nameOriginal: String?
    let description: String?
    let descriptionRaw: String?
    let backgroundImage: String?
    let backgroundImageAdditional: String?
    let released: String?
    let rating: Double
    let metacritic: Int?
    let platforms: [PlatformInfo]?
    let genres: [Genre]?
    let esrbRating: ESRBRating?
    let website: String?
    let redditUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, released, rating, metacritic, platforms, genres, website
        case nameOriginal = "name_original"
        case descriptionRaw = "description_raw"
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case esrbRating = "esrb_rating"
        case redditUrl = "reddit_url"
    }
}