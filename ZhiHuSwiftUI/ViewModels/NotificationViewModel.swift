import Foundation

@MainActor
class NotificationViewModel: ObservableObject {
    @Published private(set) var notifications: [Notification] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published var selectedType: Notification.NotificationType?
    
    private let storage = StorageService.shared
    
    var filteredNotifications: [Notification] {
        guard let type = selectedType else {
            return notifications
        }
        return notifications.filter { $0.type == type }
    }
    
    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    func fetchNotifications() async {
        isLoading = true
        error = nil
        
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            notifications = Notification.examples
            #else
            notifications = try await NetworkService.shared.fetch(.notifications)
            #endif
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func markAsRead(_ id: String) async {
        do {
            #if DEBUG
            if let index = notifications.firstIndex(where: { $0.id == id }) {
                var notification = notifications[index]
                notification = Notification(
                    id: notification.id,
                    type: notification.type,
                    sender: notification.sender,
                    content: notification.content,
                    timestamp: notification.timestamp,
                    isRead: true,
                    relatedPost: notification.relatedPost,
                    relatedComment: notification.relatedComment
                )
                notifications[index] = notification
            }
            #else
            try await NetworkService.shared.post(.markNotificationAsRead(id: id))
            await fetchNotifications()
            #endif
        } catch {
            self.error = error
        }
    }
    
    func markAllAsRead() async {
        do {
            #if DEBUG
            notifications = notifications.map { notification in
                Notification(
                    id: notification.id,
                    type: notification.type,
                    sender: notification.sender,
                    content: notification.content,
                    timestamp: notification.timestamp,
                    isRead: true,
                    relatedPost: notification.relatedPost,
                    relatedComment: notification.relatedComment
                )
            }
            #else
            try await NetworkService.shared.post(.markAllNotificationsAsRead)
            await fetchNotifications()
            #endif
        } catch {
            self.error = error
        }
    }
    
    // 添加分组枚举
    enum GroupBy {
        case time    // 按时间分组
        case type    // 按类型分组
    }
    
    @Published var groupBy: GroupBy = .time
    
    // 按时间分组的通知
    var timeGroupedNotifications: [(String, [Notification])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredNotifications) { notification -> String in
            if calendar.isDateInToday(notification.timestamp) {
                return "今天"
            } else if calendar.isDateInYesterday(notification.timestamp) {
                return "昨天"
            } else if calendar.isDate(notification.timestamp, equalTo: Date(), toGranularity: .weekOfYear) {
                return "本周"
            } else if calendar.isDate(notification.timestamp, equalTo: Date(), toGranularity: .month) {
                return "本月"
            } else {
                return "更早"
            }
        }
        
        let sortedKeys = ["今天", "昨天", "本周", "本月", "更早"]
        return sortedKeys.compactMap { key in
            if let notifications = grouped[key] {
                return (key, notifications.sorted { $0.timestamp > $1.timestamp })
            }
            return nil
        }
    }
    
    // 按类型分组的通知
    var typeGroupedNotifications: [(String, [Notification])] {
        let grouped = Dictionary(grouping: filteredNotifications) { notification -> String in
            switch notification.type {
            case .like: return "赞同和喜欢"
            case .comment: return "评论"
            case .reply: return "回复"
            case .follow: return "关注"
            case .system: return "系统通知"
            }
        }
        
        let sortedKeys = ["赞同和喜欢", "评论", "回复", "关注", "系统通知"]
        return sortedKeys.compactMap { key in
            if let notifications = grouped[key] {
                return (key, notifications.sorted { $0.timestamp > $1.timestamp })
            }
            return nil
        }
    }
} 