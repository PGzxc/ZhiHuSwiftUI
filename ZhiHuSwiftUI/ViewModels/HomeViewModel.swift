import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let storage = StorageService.shared
    
    init() {
        loadLocalData()
        Task {
            await fetchPosts()
        }
    }
    
    private func loadLocalData() {
        posts = storage.loadPosts()
    }
    
    func fetchPosts() async {
        isLoading = true
        error = nil
        
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)  // 模拟网络延迟
            posts = Post.examples
            #else
            posts = try await NetworkService.shared.fetch(.posts)
            #endif
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 