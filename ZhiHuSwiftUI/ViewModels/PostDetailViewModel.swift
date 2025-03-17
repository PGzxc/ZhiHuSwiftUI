import Foundation

@MainActor
class PostDetailViewModel: ObservableObject {
    @Published private(set) var post: PostDetail?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    let postId: String
    private let storage = StorageService.shared
    
    init(postId: String) {
        self.postId = postId
    }
    
    func fetchPostDetail() async {
        isLoading = true
        error = nil
        
        do {
            #if DEBUG
            // 模拟网络请求延迟
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            // 创建一个新的 PostDetail 实例而不是修改现有的
            let newPost = PostDetail(
                id: postId,
                author: User.example,
                title: "SwiftUI 开发技巧",
                content: """
                    在本文中，我将分享一些 SwiftUI 开发中的实用技巧...
                    
                    1. 视图组织
                    良好的视图组织能够提高代码的可维护性...
                    
                    2. 状态管理
                    合理使用 @State, @Binding, @ObservedObject...
                    
                    3. 性能优化
                    避免不必要的视图更新...
                    """,
                upvotes: 42,
                comments: [
                    PostDetail.Comment(
                        id: "1",
                        author: User(id: "2", name: "李四", avatar: "user_avatar2", headline: "iOS 开发者", following: 234, followers: 567),
                        content: "非常实用的文章，学习了！",
                        timestamp: Date(),
                        upvotes: 12,
                        replies: [
                            PostDetail.Comment.Reply(
                                id: "1",
                                author: User.example,
                                content: "谢谢支持！",
                                timestamp: Date(),
                                upvotes: 3
                            )
                        ]
                    )
                ],
                timestamp: Date(),
                topics: ["SwiftUI", "iOS开发", "编程技巧"],
                isUpvoted: false,
                isBookmarked: false
            )
            post = newPost
            #else
            post = try await NetworkService.shared.fetch(.postDetail(id: postId))
            #endif
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func toggleUpvote() async {
        do {
            #if DEBUG
            // 创建新的 PostDetail 实例来更新状态
            if var updatedPost = post {
                updatedPost = PostDetail(
                    id: updatedPost.id,
                    author: updatedPost.author,
                    title: updatedPost.title,
                    content: updatedPost.content,
                    upvotes: updatedPost.isUpvoted ? updatedPost.upvotes - 1 : updatedPost.upvotes + 1,
                    comments: updatedPost.comments,
                    timestamp: updatedPost.timestamp,
                    topics: updatedPost.topics,
                    isUpvoted: !updatedPost.isUpvoted,
                    isBookmarked: updatedPost.isBookmarked
                )
                post = updatedPost
            }
            #else
            try await NetworkService.shared.post(.toggleUpvote(postId: postId))
            await fetchPostDetail()
            #endif
        } catch {
            self.error = error
        }
    }
    
    func toggleBookmark() async {
        do {
            #if DEBUG
            // 创建新的 PostDetail 实例来更新状态
            if var updatedPost = post {
                updatedPost = PostDetail(
                    id: updatedPost.id,
                    author: updatedPost.author,
                    title: updatedPost.title,
                    content: updatedPost.content,
                    upvotes: updatedPost.upvotes,
                    comments: updatedPost.comments,
                    timestamp: updatedPost.timestamp,
                    topics: updatedPost.topics,
                    isUpvoted: updatedPost.isUpvoted,
                    isBookmarked: !updatedPost.isBookmarked
                )
                post = updatedPost
            }
            #else
            try await NetworkService.shared.post(.toggleBookmark(postId: postId))
            await fetchPostDetail()
            #endif
        } catch {
            self.error = error
        }
    }
} 