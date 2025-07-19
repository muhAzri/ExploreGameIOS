import Foundation

protocol AboutPresenterProtocol: ObservableObject {
    var fullName: String { get }
    var bio: String { get }
    var profileImageName: String { get }
    var email: String { get }
    var isEditingProfile: Bool { get }
    
    func startEditingProfile()
    func saveProfile(name: String, email: String, bio: String)
    func cancelEditing()
}

class AboutPresenter: AboutPresenterProtocol {
    @Published var isEditingProfile = false
    
    private let router: AboutRouterProtocol
    private let userDefaultsManager = UserDefaultsManager.shared
    
    var fullName: String {
        userDefaultsManager.userName
    }
    
    var bio: String {
        userDefaultsManager.userBio
    }
    
    var email: String {
        userDefaultsManager.userEmail
    }
    
    let profileImageName = "About"
    
    init(router: AboutRouterProtocol) {
        self.router = router
    }
    
    func startEditingProfile() {
        isEditingProfile = true
    }
    
    func saveProfile(name: String, email: String, bio: String) {
        userDefaultsManager.updateProfile(name: name, email: email, bio: bio)
        isEditingProfile = false
    }
    
    func cancelEditing() {
        isEditingProfile = false
    }
}
