import Foundation

struct Column: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let image: String
    let author: String
    let articlesCount: Int
    let followersCount: Int
    var isFollowing: Bool
    
    static let examples = [
        Column(
            id: "1",
            title: "SwiftUI 实战",
            description: "从零开始学习 SwiftUI 开发",
            image: "column_image1",
            author: "张三",
            articlesCount: 42,
            followersCount: 1234,
            isFollowing: false
        ),
        Column(
            id: "2",
            title: "iOS 开发进阶",
            description: "深入理解 iOS 开发的各个方面",
            image: "column_image2",
            author: "李四",
            articlesCount: 56,
            followersCount: 2345,
            isFollowing: true
        ),
        Column(
            id: "3",
            title: "Swift 编程技巧",
            description: "分享 Swift 编程中的实用技巧",
            image: "column_image3",
            author: "王五",
            articlesCount: 38,
            followersCount: 3456,
            isFollowing: false
        )
    ]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case image
        case author
        case articlesCount = "articles_count"
        case followersCount = "followers_count"
        case isFollowing = "is_following"
    }
}

extension Column: Equatable {
    static func == (lhs: Column, rhs: Column) -> Bool {
        lhs.id == rhs.id
    }
}

extension Column: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
} 