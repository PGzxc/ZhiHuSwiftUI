import Foundation

struct Notification: Identifiable, Codable {
    let id: String
    let type: NotificationType
    let sender: User
    let content: String
    let timestamp: Date
    let isRead: Bool
    let relatedPost: Post?
    let relatedComment: String?
    
    enum NotificationType: String, Codable {
        case like = "like"           // 点赞
        case comment = "comment"     // 评论
        case reply = "reply"         // 回复
        case follow = "follow"       // 关注
        case system = "system"       // 系统通知
        
        var icon: String {
            switch self {
            case .like: return "hand.thumbsup.fill"
            case .comment: return "text.bubble.fill"
            case .reply: return "arrowshape.turn.up.left.fill"
            case .follow: return "person.fill.badge.plus"
            case .system: return "bell.fill"
            }
        }
        
        var color: String {
            switch self {
            case .like: return "red"
            case .comment: return "blue"
            case .reply: return "green"
            case .follow: return "purple"
            case .system: return "orange"
            }
        }
    }
    
    static let examples = [
        Notification(
            id: "1",
            type: .like,
            sender: User.example,
            content: "赞了你的文章",
            timestamp: Date().addingTimeInterval(-300),
            isRead: false,
            relatedPost: Post.example,
            relatedComment: nil
        ),
        Notification(
            id: "2",
            type: .comment,
            sender: User.examples[1],
            content: "评论了你的文章：非常实用的分享！",
            timestamp: Date().addingTimeInterval(-3600),
            isRead: false,
            relatedPost: Post.examples[0],
            relatedComment: "非常实用的分享！"
        ),
        Notification(
            id: "3",
            type: .reply,
            sender: User.examples[2],
            content: "回复了你的评论：完全同意你的观点",
            timestamp: Date().addingTimeInterval(-7200),
            isRead: true,
            relatedPost: Post.examples[1],
            relatedComment: "完全同意你的观点"
        ),
        Notification(
            id: "4",
            type: .follow,
            sender: User.examples[3],
            content: "关注了你",
            timestamp: Date().addingTimeInterval(-86400),
            isRead: true,
            relatedPost: nil,
            relatedComment: nil
        ),
        Notification(
            id: "5",
            type: .system,
            sender: User(id: "system", name: "知乎", avatar: "zhihu_logo", headline: "系统通知", following: 0, followers: 0),
            content: "欢迎使用知乎，这里有海量优质内容等你发现",
            timestamp: Date().addingTimeInterval(-172800),
            isRead: false,
            relatedPost: nil,
            relatedComment: nil
        )
    ]
} 