import Foundation
import Combine

protocol GameListInteractorProtocol {
    func fetchGames(page: Int) -> AnyPublisher<GameResponse, NetworkError>
    func searchGames(query: String, page: Int) -> AnyPublisher<GameResponse, NetworkError>
}

class GameListInteractor: GameListInteractorProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchGames(page: Int) -> AnyPublisher<GameResponse, NetworkError> {
        return networkManager.request(.games(search: nil, page: page))
    }
    
    func searchGames(query: String, page: Int) -> AnyPublisher<GameResponse, NetworkError> {
        return networkManager.request(.games(search: query, page: page))
    }
}