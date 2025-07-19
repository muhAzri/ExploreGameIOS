import Foundation

class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()
    
    private enum Keys {
        static let userName = "userName"
        static let userEmail = "userEmail"
        static let userBio = "userBio"
    }
    
    @Published var userName: String {
        didSet {
            UserDefaults.standard.set(userName, forKey: Keys.userName)
        }
    }
    
    @Published var userEmail: String {
        didSet {
            UserDefaults.standard.set(userEmail, forKey: Keys.userEmail)
        }
    }
    
    @Published var userBio: String {
        didSet {
            UserDefaults.standard.set(userBio, forKey: Keys.userBio)
        }
    }
    
    private init() {
        self.userName = UserDefaults.standard.string(forKey: Keys.userName) ?? "Muhammad Azri Fatihah Susanto"
        self.userEmail = UserDefaults.standard.string(forKey: Keys.userEmail) ?? "muhammad.azri.f.s@gmail.com"
        self.userBio = UserDefaults.standard.string(forKey: Keys.userBio) ?? "Mobile App Developer"
    }
    
    func updateProfile(name: String, email: String, bio: String) {
        userName = name
        userEmail = email
        userBio = bio
    }
    
    func resetToDefaults() {
        userName = "Muhammad Azri Fatihah Susanto"
        userEmail = "muhammad.azri.f.s@gmail.com"
        userBio = "Mobile App Developer"
    }
}