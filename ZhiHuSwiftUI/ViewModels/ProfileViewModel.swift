import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var isLoading = false
    @Published var error: ProfileError?
    @Published var settings = UserSettings.default
    
    private let storage = StorageService.shared
    
    var isLoggedIn: Bool {
        user != nil
    }
    
    func fetchUserProfile() async {
        isLoading = true
        error = nil
        
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            user = User.example
            #else
            do {
                user = try await NetworkService.shared.fetch(.userProfile)
            } catch let networkError as NetworkError {
                switch networkError {
                case .unauthorized:
                    throw ProfileError.unauthorized
                case .notFound:
                    throw ProfileError.notFound
                case .serverError:
                    throw ProfileError.serverError
                default:
                    throw ProfileError.unknown
                }
            }
            #endif
        } catch {
            if let profileError = error as? ProfileError {
                self.error = profileError
            } else {
                self.error = .networkError
            }
        }
        
        isLoading = false
    }
    
    func logout() async {
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            user = nil
            #else
            do {
                try await NetworkService.shared.post(.logout)
                user = nil
            } catch {
                throw ProfileError.serverError
            }
            #endif
        } catch {
            if let profileError = error as? ProfileError {
                self.error = profileError
            } else {
                self.error = .unknown
            }
        }
    }
    
    func updateSettings() async {
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            #else
            do {
                try await NetworkService.shared.post(.updateSettings, body: settings)
            } catch {
                throw ProfileError.serverError
            }
            #endif
        } catch {
            if let profileError = error as? ProfileError {
                self.error = profileError
            } else {
                self.error = .unknown
            }
        }
    }
} 