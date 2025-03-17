import Foundation

struct Question: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let author: User
    let answersCount: Int
    let followersCount: Int
    let timestamp: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case author
        case answersCount = "answers_count"
        case followersCount = "followers_count"
        case timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        author = try container.decode(User.self, forKey: .author)
        answersCount = try container.decode(Int.self, forKey: .answersCount)
        followersCount = try container.decode(Int.self, forKey: .followersCount)
        
        // 处理日期解码
        let timestampString = try container.decode(String.self, forKey: .timestamp)
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: timestampString) {
            timestamp = date
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .timestamp,
                in: container,
                debugDescription: "Date string does not match format"
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(author, forKey: .author)
        try container.encode(answersCount, forKey: .answersCount)
        try container.encode(followersCount, forKey: .followersCount)
        
        // 处理日期编码
        let formatter = ISO8601DateFormatter()
        let timestampString = formatter.string(from: timestamp)
        try container.encode(timestampString, forKey: .timestamp)
    }
    
    static let example = Question(
        id: "1",
        title: "如何学习 SwiftUI？",
        content: "作为一个 iOS 开发新手，想要学习 SwiftUI，有什么好的建议吗？",
        author: User.example,
        answersCount: 42,
        followersCount: 128,
        timestamp: Date()
    )
    
    // 添加初始化方法
    init(id: String, title: String, content: String, author: User, answersCount: Int, followersCount: Int, timestamp: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.author = author
        self.answersCount = answersCount
        self.followersCount = followersCount
        self.timestamp = timestamp
    }
} 