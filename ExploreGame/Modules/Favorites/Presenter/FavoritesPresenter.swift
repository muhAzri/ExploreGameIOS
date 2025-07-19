import Foundation

protocol FavoritesPresenterProtocol: ObservableObject {
    var favorites: [FavoriteGameEntity] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func loadFavorites()
    func removeFromFavorites(_ gameID: Int)
    func clearError()
}

class FavoritesPresenter: FavoritesPresenterProtocol {
    @Published var favorites: [FavoriteGameEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let interactor: FavoritesInteractorProtocol
    
    init(interactor: FavoritesInteractorProtocol = FavoritesInteractor()) {
        self.interactor = interactor
    }
    
    func loadFavorites() {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.main.async {
            self.favorites = self.interactor.fetchFavorites()
            self.isLoading = false
        }
    }
    
    func removeFromFavorites(_ gameID: Int) {
        interactor.removeFromFavorites(gameID)
        loadFavorites()
    }
    
    func clearError() {
        errorMessage = nil
    }
}