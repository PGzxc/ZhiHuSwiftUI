import Foundation

struct HotTopic: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let questionsCount: Int
    let followersCount: Int
    var isFollowing: Bool
    
    static let examples = [
        HotTopic(
            id: "1",
            title: "iOS 开发",
            description: "iOS 开发相关讨论",
            questionsCount: 1234,
            followersCount: 5678,
            isFollowing: false
        ),
        HotTopic(
            id: "2",
            title: "SwiftUI",
            description: "SwiftUI 相关讨论",
            questionsCount: 890,
            followersCount: 1234,
            isFollowing: true
        ),
        HotTopic(
            id: "3",
            title: "Swift",
            description: "Swift 编程语言相关讨论",
            questionsCount: 5678,
            followersCount: 9012,
            isFollowing: false
        )
    ]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case questionsCount = "questions_count"
        case followersCount = "followers_count"
        case isFollowing = "is_following"
    }
}

extension HotTopic: Equatable {
    static func == (lhs: HotTopic, rhs: HotTopic) -> Bool {
        lhs.id == rhs.id
    }
}

extension HotTopic: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
} 