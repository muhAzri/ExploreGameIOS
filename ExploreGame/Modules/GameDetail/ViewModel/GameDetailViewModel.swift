import Foundation
import Combine

protocol GameDetailViewModelProtocol: ObservableObject {
    var gameDetail: GameDetail? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func loadGameDetail(id: Int)
    func clearError()
}

class GameDetailViewModel: GameDetailViewModelProtocol {
    @Published var gameDetail: GameDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let gameDetailService: GameDetailServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(gameDetailService: GameDetailServiceProtocol = GameDetailService()) {
        self.gameDetailService = gameDetailService
    }
    
    deinit {
    }
    
    func loadGameDetail(id: Int) {
        isLoading = true
        errorMessage = nil
        
        gameDetailService.fetchGameDetail(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] gameDetail in
                    self?.gameDetail = gameDetail
                }
            )
            .store(in: &cancellables)
    }
    
    func clearError() {
        errorMessage = nil
    }
}
