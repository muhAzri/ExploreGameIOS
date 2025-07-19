import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    @Published var favoriteGameIDs: Set<Int> = []
    
    private init() {
        updateFavoriteIDs()
        
        // Listen for Core Data changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextDidSave),
            name: .NSManagedObjectContextDidSave,
            object: persistentContainer.viewContext
        )
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteGameModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    @objc private func contextDidSave() {
        DispatchQueue.main.async {
            self.updateFavoriteIDs()
        }
    }
    
    private func updateFavoriteIDs() {
        favoriteGameIDs = Set(fetchFavorites().map { Int($0.gameID) })
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func addToFavorites(_ game: Game) {
        let favoriteGame = FavoriteGame(context: context)
        favoriteGame.gameID = Int32(game.id)
        favoriteGame.name = game.name
        favoriteGame.backgroundImage = game.backgroundImage
        favoriteGame.released = game.released
        favoriteGame.rating = game.rating
        favoriteGame.metacritic = Int32(game.metacritic ?? 0)
        favoriteGame.dateAdded = Date()
        
        if let genres = game.genres {
            favoriteGame.genres = genres.map { $0.name }.joined(separator: ", ")
        }
        
        if let platforms = game.platforms {
            favoriteGame.platforms = platforms.map { $0.platform.name }.joined(separator: ", ")
        }
        
        save()
    }
    
    func removeFromFavorites(_ gameID: Int) {
        let request: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        request.predicate = NSPredicate(format: "gameID == %d", gameID)
        
        do {
            let results = try context.fetch(request)
            for game in results {
                context.delete(game)
            }
            save()
        } catch {
            print("Failed to remove from favorites: \(error)")
        }
    }
    
    func isFavorite(_ gameID: Int) -> Bool {
        return favoriteGameIDs.contains(gameID)
    }
    
    func fetchFavorites() -> [FavoriteGame] {
        let request: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteGame.dateAdded, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}