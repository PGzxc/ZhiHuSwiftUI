import Foundation

struct ShareContent {
    let title: String
    let content: String
    let url: URL
    let author: String
    let topics: [String]
    
    static func from(post: PostDetail) -> ShareContent {
        ShareContent(
            title: post.title,
            content: post.content,
            url: URL(string: "https://zhihu.com/p/\(post.id)")!,
            author: post.author.name,
            topics: post.topics
        )
    }
} 