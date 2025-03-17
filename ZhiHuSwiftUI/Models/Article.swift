import Foundation

struct Article: Identifiable, Codable {
    let id: String
    let title: String
    let summary: String
    let author: User
    let readCount: Int
    let likesCount: Int
    let timestamp: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case summary
        case author
        case readCount = "read_count"
        case likesCount = "likes_count"
        case timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        summary = try container.decode(String.self, forKey: .summary)
        author = try container.decode(User.self, forKey: .author)
        readCount = try container.decode(Int.self, forKey: .readCount)
        likesCount = try container.decode(Int.self, forKey: .likesCount)
        
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
        try container.encode(summary, forKey: .summary)
        try container.encode(author, forKey: .author)
        try container.encode(readCount, forKey: .readCount)
        try container.encode(likesCount, forKey: .likesCount)
        
        // 处理日期编码
        let formatter = ISO8601DateFormatter()
        let timestampString = formatter.string(from: timestamp)
        try container.encode(timestampString, forKey: .timestamp)
    }
    
    static let example = Article(
        id: "1",
        title: "SwiftUI 开发实战",
        summary: "本文将介绍 SwiftUI 开发中的常见问题和解决方案...",
        author: User.example,
        readCount: 1234,
        likesCount: 567,
        timestamp: Date()
    )
    
    // 添加初始化方法
    init(id: String, title: String, summary: String, author: User, readCount: Int, likesCount: Int, timestamp: Date) {
        self.id = id
        self.title = title
        self.summary = summary
        self.author = author
        self.readCount = readCount
        self.likesCount = likesCount
        self.timestamp = timestamp
    }
} 