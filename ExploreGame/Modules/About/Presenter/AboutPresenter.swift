import Foundation

protocol AboutPresenterProtocol: ObservableObject {
    var fullName: String { get }
    var bio: String { get }
    var profileImageName: String { get }
}

class AboutPresenter: AboutPresenterProtocol {
    let fullName = "Muhammad Azri Fatihah Susanto"
    let bio = "Mobile Developer specializing in iOS, Android, and cross-platform development. Passionate about creating exceptional mobile experiences with native and Flutter technologies."
    let profileImageName = "About"
    
    private let router: AboutRouterProtocol
    
    init(router: AboutRouterProtocol) {
        self.router = router
    }
}