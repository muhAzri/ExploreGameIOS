import Foundation
import CoreData

struct FavoriteGameEntity {
    let gameID: Int
    let name: String
    let backgroundImage: String?
    let released: String?
    let rating: Double
    let metacritic: Int?
    let genres: String?
    let platforms: String?
    let dateAdded: Date
}

extension FavoriteGame {
    func toEntity() -> FavoriteGameEntity {
        return FavoriteGameEntity(
            gameID: Int(self.gameID),
            name: self.name ?? "",
            backgroundImage: self.backgroundImage,
            released: self.released,
            rating: self.rating,
            metacritic: self.metacritic == 0 ? nil : Int(self.metacritic),
            genres: self.genres,
            platforms: self.platforms,
            dateAdded: self.dateAdded ?? Date()
        )
    }
    
    func toGame() -> Game {
        let genresArray = self.genres?.components(separatedBy: ", ").map { genreName in
            Genre(id: 0, name: genreName, slug: genreName.lowercased())
        }
        
        let platformsArray = self.platforms?.components(separatedBy: ", ").map { platformName in
            PlatformInfo(platform: Platform(id: 0, name: platformName, slug: platformName.lowercased()))
        }
        
        return Game(
            id: Int(self.gameID),
            name: self.name ?? "",
            backgroundImage: self.backgroundImage,
            released: self.released,
            rating: self.rating,
            metacritic: self.metacritic == 0 ? nil : Int(self.metacritic),
            platforms: platformsArray,
            genres: genresArray,
            esrbRating: nil
        )
    }
}