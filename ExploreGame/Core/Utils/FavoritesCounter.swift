import Foundation
import Combine

class FavoritesCounter: ObservableObject {
    @Published var count: Int = 0
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        updateCount()
        
        // Listen for Core Data changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextDidSave),
            name: .NSManagedObjectContextDidSave,
            object: coreDataManager.context
        )
    }
    
    @objc private func contextDidSave() {
        DispatchQueue.main.async {
            self.updateCount()
        }
    }
    
    private func updateCount() {
        count = coreDataManager.fetchFavorites().count
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}