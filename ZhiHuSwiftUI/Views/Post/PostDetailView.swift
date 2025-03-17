import SwiftUI

struct PostDetailView: View {
    @StateObject private var viewModel: PostDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingCommentEditor = false
    @State private var showingShareSheet = false
    
    init(postId: String) {
        _viewModel = StateObject(wrappedValue: PostDetailViewModel(postId: postId))
    }
    
    var body: some View {
        ScrollView {
            if let post = viewModel.post {
                VStack(alignment: .leading, spacing: 16) {
                    // 标题
                    Text(post.title)
                        .font(.title)
                        .bold()
                    
                    // 作者信息
                    HStack {
                        AsyncImage(url: URL(string: post.author.avatar)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(post.author.name)
                                .font(.headline)
                            Text(post.author.headline)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Text("关注")
                                .foregroundColor(.blue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        }
                    }
                    
                    // 话题标签
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(post.topics, id: \.self) { topic in
                                Text(topic)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                            }
                        }
                    }
                    
                    // 内容
                    Text(post.content)
                        .font(.body)
                    
                    // 互动栏
                    HStack(spacing: 20) {
                        Button {
                            Task {
                                await viewModel.toggleUpvote()
                            }
                        } label: {
                            Label("\(post.upvotes)", systemImage: post.isUpvoted ? "hand.thumbsup.fill" : "hand.thumbsup")
                        }
                        
                        Label("\(post.comments.count)", systemImage: "text.bubble")
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await viewModel.toggleBookmark()
                            }
                        } label: {
                            Image(systemName: post.isBookmarked ? "bookmark.fill" : "bookmark")
                        }
                        
                        Button {
                            showingShareSheet = true
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    .foregroundColor(.gray)
                    
                    Divider()
                    
                    // 评论区
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("评论 \(post.comments.count)")
                                .font(.headline)
                            Spacer()
                            Button {
                                showingCommentEditor = true
                            } label: {
                                Label("写评论", systemImage: "square.and.pencil")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        ForEach(post.comments) { comment in
                            CommentView(postId: viewModel.postId, comment: comment)
                        }
                    }
                }
                .padding()
            } else if viewModel.isLoading {
                ContentLoadingView()
            } else if let error = viewModel.error {
                LoadingErrorView(error: error) {
                    Task {
                        await viewModel.fetchPostDetail()
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchPostDetail()
        }
        .sheet(isPresented: $showingCommentEditor) {
            CommentEditorView(postId: viewModel.postId)
                .onDisappear {
                    // 评论发布后刷新帖子详情
                    if !showingCommentEditor {
                        Task {
                            await viewModel.fetchPostDetail()
                        }
                    }
                }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let post = viewModel.post {
                ShareSheetView(content: ShareContent.from(post: post))
            }
        }
    }
}

// 评论视图组件
struct CommentView: View {
    let postId: String
    let comment: PostDetail.Comment
    @State private var showingReplyEditor = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 评论作者信息
            HStack {
                AsyncImage(url: URL(string: comment.author.avatar)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(comment.author.name)
                        .font(.subheadline)
                        .bold()
                    Text(comment.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // 评论内容
            Text(comment.content)
                .font(.body)
            
            // 评论互动
            HStack {
                Label("\(comment.upvotes)", systemImage: "hand.thumbsup")
                    .foregroundColor(.gray)
                Spacer()
                Button("回复") {
                    showingReplyEditor = true
                }
                .foregroundColor(.gray)
            }
            
            // 回复列表
            if !comment.replies.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(comment.replies) { reply in
                        ReplyView(postId: postId, commentId: comment.id, reply: reply)
                    }
                }
                .padding(.leading)
            }
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showingReplyEditor) {
            ReplyEditorView(
                postId: postId,
                commentId: comment.id,
                replyTo: comment.author.name
            )
        }
    }
}

// 回复视图组件
struct ReplyView: View {
    let postId: String
    let commentId: String
    let reply: PostDetail.Comment.Reply
    @State private var showingReplyEditor = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                AsyncImage(url: URL(string: reply.author.avatar)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 24, height: 24)
                .clipShape(Circle())
                
                Text(reply.author.name)
                    .font(.subheadline)
                    .bold()
                
                Text(reply.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(reply.content)
                .font(.subheadline)
            
            HStack {
                Label("\(reply.upvotes)", systemImage: "hand.thumbsup")
                    .foregroundColor(.gray)
                Spacer()
                Button("回复") {
                    showingReplyEditor = true
                }
                .foregroundColor(.gray)
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
        .sheet(isPresented: $showingReplyEditor) {
            ReplyEditorView(
                postId: postId,
                commentId: commentId,
                replyTo: reply.author.name
            )
        }
    }
} 