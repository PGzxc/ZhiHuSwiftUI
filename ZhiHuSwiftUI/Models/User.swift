import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let avatar: String
    let headline: String
    let following: Int
    let followers: Int
    
    static let example = User(
        id: "1",
        name: "张三",
        avatar: "user_avatar1",
        headline: "SwiftUI 开发者",
        following: 123,
        followers: 456
    )
    
    static let examples = [
        example,
        User(
            id: "2",
            name: "李四",
            avatar: "user_avatar2",
            headline: "iOS 开发工程师",
            following: 234,
            followers: 567
        ),
        User(
            id: "3",
            name: "王五",
            avatar: "user_avatar3",
            headline: "Swift 技术专家",
            following: 789,
            followers: 1234
        ),
        User(
            id: "4",
            name: "赵六",
            avatar: "user_avatar4",
            headline: "移动架构师",
            following: 345,
            followers: 789
        ),
        User(
            id: "5",
            name: "孙七",
            avatar: "user_avatar5",
            headline: "独立开发者",
            following: 123,
            followers: 456
        )
    ]
} 