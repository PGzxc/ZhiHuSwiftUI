import Foundation

@MainActor
class NotificationReplyViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    func submitReply(content: String) async {
        isLoading = true
        error = nil
        
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            #else
            try await NetworkService.shared.post(
                .replyToNotification(id: notification.id),
                body: [
                    "content": content,
                    "type": notification.type.rawValue
                ]
            )
            #endif
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 