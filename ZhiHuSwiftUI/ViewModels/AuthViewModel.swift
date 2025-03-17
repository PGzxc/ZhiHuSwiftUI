import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published private(set) var isAuthenticated = false
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let authService = AuthService.shared
    
    init() {
        isAuthenticated = authService.isLoggedIn
    }
    
    func login(username: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            _ = try await authService.login(username: username, password: password)
            isAuthenticated = true
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func register(username: String, password: String, name: String) async {
        isLoading = true
        error = nil
        
        do {
            // 注册成功后自动登录
            let user = User(
                id: UUID().uuidString,
                name: name,
                avatar: "user_avatar1",
                headline: "新用户",
                following: 0,
                followers: 0
            )
            try authService.updateUser(user)
            isAuthenticated = true
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func logout() {
        do {
            try authService.logout()
            isAuthenticated = false
        } catch {
            self.error = error
        }
    }
} 