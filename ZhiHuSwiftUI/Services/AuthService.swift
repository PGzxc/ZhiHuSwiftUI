import Foundation

@MainActor
class AuthService {
    static let shared = AuthService()
    private let storage = StorageService.shared
    private let userKey = "stored_user"
    
    private init() {}
    
    var currentUser: User? {
        try? storage.load(User.self, for: userKey)
    }
    
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    func login(username: String, password: String) async throws -> User {
        // 模拟网络请求
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let user = User.example
        try storage.save(user, for: userKey)
        return user
    }
    
    func logout() throws {
        storage.remove(for: userKey)
    }
    
    func updateUser(_ user: User) throws {
        try storage.save(user, for: userKey)
    }
} 