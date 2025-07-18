import Foundation
import Combine

class SimpleGameDetailPresenter: ObservableObject {
    @Published var gameDetail: GameDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
    }
    
    deinit {
    }
    
    func loadGameDetail(id: Int) {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.request(APIEndpoint.gameDetail(id: id))
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
                receiveValue: { [weak self] (gameDetail: GameDetail) in
                    self?.gameDetail = gameDetail
                }
            )
            .store(in: &cancellables)
    }
    
    func clearError() {
        errorMessage = nil
    }
}
