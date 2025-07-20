import Foundation
import Combine

protocol GameListServiceProtocol {
    func fetchGames(page: Int) -> AnyPublisher<GameResponse, NetworkError>
    func searchGames(query: String, page: Int) -> AnyPublisher<GameResponse, NetworkError>
}

class GameListService: GameListServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchGames(page: Int) -> AnyPublisher<GameResponse, NetworkError> {
        networkManager.request(.games(search: nil, page: page))
    }
    
    func searchGames(query: String, page: Int) -> AnyPublisher<GameResponse, NetworkError> {
        networkManager.request(.games(search: query, page: page))
    }
}
