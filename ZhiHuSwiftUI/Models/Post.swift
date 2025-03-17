import Foundation

struct Post: Identifiable, Codable {
    let id: String
    let author: User
    let title: String
    let content: String
    let upvotes: Int
    let comments: Int
    let timestamp: Date
    
    static let examples = [
        Post(
            id: "1",
            author: User.example,
            title: "SwiftUI 开发技巧分享",
            content: """
                在本文中，我将分享一些 SwiftUI 开发中的实用技巧：
                
                1. 视图组织：如何合理组织和拆分视图组件
                2. 状态管理：@State, @Binding 等的最佳实践
                3. 性能优化：避免不必要的视图更新
                """,
            upvotes: 128,
            comments: 32,
            timestamp: Date().addingTimeInterval(-3600 * 24)  // 1天前
        ),
        
        Post(
            id: "2",
            author: User(
                id: "2",
                name: "李四",
                avatar: "user_avatar2",
                headline: "iOS 开发工程师",
                following: 234,
                followers: 567
            ),
            title: "iOS 16 新特性解析",
            content: """
                iOS 16 带来了许多激动人心的新特性，包括：
                
                - Lock Screen 自定义
                - Focus Filter
                - Live Text 增强
                - Metal 3 游戏优化
                """,
            upvotes: 256,
            comments: 48,
            timestamp: Date().addingTimeInterval(-3600 * 2)  // 2小时前
        ),
        
        Post(
            id: "3",
            author: User(
                id: "3",
                name: "王五",
                avatar: "user_avatar3",
                headline: "Swift 技术专家",
                following: 789,
                followers: 1234
            ),
            title: "Swift 并发编程实战",
            content: """
                Swift 5.5 引入的 async/await 让并发编程变得更加简单。
                
                本文将介绍：
                - async/await 基础用法
                - Actor 模型
                - 结构化并发
                - 实际项目应用
                """,
            upvotes: 512,
            comments: 96,
            timestamp: Date().addingTimeInterval(-3600 * 0.5)  // 30分钟前
        ),
        
        Post(
            id: "4",
            author: User(
                id: "4",
                name: "赵六",
                avatar: "user_avatar4",
                headline: "移动架构师",
                following: 345,
                followers: 789
            ),
            title: "SwiftUI 性能优化指南",
            content: """
                如何提升 SwiftUI 应用的性能？本文将从以下几个方面展开：
                
                1. 视图更新优化
                2. 内存管理
                3. 网络请求优化
                4. 图片加载优化
                """,
            upvotes: 384,
            comments: 64,
            timestamp: Date().addingTimeInterval(-3600 * 12)  // 12小时前
        ),
        
        Post(
            id: "5",
            author: User(
                id: "5",
                name: "孙七",
                avatar: "user_avatar5",
                headline: "独立开发者",
                following: 123,
                followers: 456
            ),
            title: "从0到1开发一个 App",
            content: """
                分享我的独立开发经验：
                
                - 产品定位与规划
                - 技术选型
                - 开发流程
                - 上架经验
                - 营销推广
                """,
            upvotes: 768,
            comments: 128,
            timestamp: Date().addingTimeInterval(-3600 * 48)  // 2天前
        )
    ]
    
    static let example = examples[0]
} 