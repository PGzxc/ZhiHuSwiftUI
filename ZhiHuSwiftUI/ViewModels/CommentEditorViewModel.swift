import Foundation

@MainActor
class CommentEditorViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let postId: String
    
    init(postId: String) {
        self.postId = postId
    }
    
    func submitComment(content: String) async {
        isLoading = true
        error = nil
        
        do {
            #if DEBUG
            // 模拟网络请求延迟
            try await Task.sleep(nanoseconds: 1_000_000_000)
            #else
            try await NetworkService.shared.post(
                .createComment(postId: postId),
                body: ["content": content]
            )
            #endif
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 