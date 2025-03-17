import Foundation

@MainActor
class ReplyEditorViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let postId: String
    private let commentId: String
    let replyTo: String
    
    init(postId: String, commentId: String, replyTo: String) {
        self.postId = postId
        self.commentId = commentId
        self.replyTo = replyTo
    }
    
    func submitReply(content: String) async {
        isLoading = true
        error = nil
        
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            #else
            try await NetworkService.shared.post(
                .createReply(postId: postId, commentId: commentId),
                body: ["content": content]
            )
            #endif
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 