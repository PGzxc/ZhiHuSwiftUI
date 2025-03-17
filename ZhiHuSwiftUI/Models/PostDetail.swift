import Foundation

struct PostDetail: Identifiable, Codable {
    let id: String
    let author: User
    let title: String
    let content: String
    let upvotes: Int
    let comments: [Comment]
    let timestamp: Date
    let topics: [String]
    let isUpvoted: Bool
    let isBookmarked: Bool
    
    struct Comment: Identifiable, Codable {
        let id: String
        let author: User
        let content: String
        let timestamp: Date
        let upvotes: Int
        let replies: [Reply]
        
        struct Reply: Identifiable, Codable {
            let id: String
            let author: User
            let content: String
            let timestamp: Date
            let upvotes: Int
        }
    }
} 