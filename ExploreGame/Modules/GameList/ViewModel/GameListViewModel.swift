import Foundation
import Combine

protocol GameListViewModelProtocol: ObservableObject {
    var games: [Game] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var searchText: String { get set }
    var selectedGame: Game? { get set }
    var shouldNavigateToAbout: Bool { get set }
    
    func loadGames()
    func loadMoreGames()
    func refreshGames()
    func searchGames()
    func clearError()
    func selectGame(_ game: Game)
    func navigateToAbout()
}

class GameListViewModel: GameListViewModelProtocol {
    @Published var games: [Game] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var selectedGame: Game?
    @Published var shouldNavigateToAbout: Bool = false
    
    private let gameService: GameListServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var canLoadMore = true
    
    init(gameService: GameListServiceProtocol = GameListService()) {
        self.gameService = gameService
        
        setupSearchBinding()
    }
    
    func loadGames() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        currentPage = 1
        
        gameService.fetchGames(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.games = response.results
                    self?.canLoadMore = response.next != nil
                }
            )
            .store(in: &cancellables)
    }
    
    func loadMoreGames() {
        guard !isLoading && canLoadMore else { return }
        
        isLoading = true
        currentPage += 1
        
        let publisher = searchText.isEmpty ? 
            gameService.fetchGames(page: currentPage) : 
            gameService.searchGames(query: searchText, page: currentPage)
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.games.append(contentsOf: response.results)
                    self?.canLoadMore = response.next != nil
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshGames() {
        games.removeAll()
        loadGames()
    }
    
    func searchGames() {
        guard !searchText.isEmpty else {
            refreshGames()
            return
        }
        
        isLoading = true
        errorMessage = nil
        currentPage = 1
        
        gameService.searchGames(query: searchText, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.games = response.results
                    self?.canLoadMore = response.next != nil
                }
            )
            .store(in: &cancellables)
    }
    
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.searchGames()
            }
            .store(in: &cancellables)
    }
    
    func selectGame(_ game: Game) {
        selectedGame = game
    }
    
    func navigateToAbout() {
        shouldNavigateToAbout = true
    }
    
    func clearError() {
        errorMessage = nil
    }
}
