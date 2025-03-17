import SwiftUI

struct NotificationDetailView: View {
    let notification: Notification
    @Environment(\.dismiss) private var dismiss
    @State private var showingRelatedPost = false
    @State private var showingReplySheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 发送者信息
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: notification.sender.avatar)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(notification.sender.name)
                            .font(.headline)
                        Text(notification.sender.headline)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    if notification.type == .follow {
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
                }
                
                // 通知类型图标和时间
                HStack {
                    Image(systemName: notification.type.icon)
                        .foregroundColor(Color(notification.type.color))
                    Text(notification.timestamp, style: .relative)
                        .foregroundColor(.gray)
                }
                .font(.subheadline)
                
                Divider()
                
                // 通知内容
                VStack(alignment: .leading, spacing: 12) {
                    Text(notification.content)
                        .font(.body)
                    
                    if let comment = notification.relatedComment {
                        Text(comment)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
                
                // 相关文章
                if let post = notification.relatedPost {
                    Divider()
                    
                    Button {
                        showingRelatedPost = true
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("相关文章")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(post.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            
                            Text(post.content)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(3)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                
                // 操作按钮
                HStack(spacing: 20) {
                    switch notification.type {
                    case .like, .comment, .reply:
                        Button {
                            showingReplySheet = true
                        } label: {
                            Label("回复", systemImage: "arrowshape.turn.up.left")
                        }
                    case .follow:
                        Button {
                            // 查看主页
                        } label: {
                            Label("查看主页", systemImage: "person")
                        }
                    case .system:
                        Button {
                            // 查看详情
                        } label: {
                            Label("查看详情", systemImage: "info.circle")
                        }
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button(role: .destructive) {
                            // 删除通知
                        } label: {
                            Label("删除通知", systemImage: "trash")
                        }
                        
                        Button {
                            // 屏蔽此类通知
                        } label: {
                            Label("屏蔽此类通知", systemImage: "bell.slash")
                        }
                        
                        if notification.type == .follow {
                            Button(role: .destructive) {
                                // 屏蔽此用户
                            } label: {
                                Label("屏蔽此用户", systemImage: "person.slash")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding(8)
                    }
                }
                .foregroundColor(.gray)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showingRelatedPost) {
            if let post = notification.relatedPost {
                PostDetailView(postId: post.id)
            }
        }
        .sheet(isPresented: $showingReplySheet) {
            NotificationReplyView(notification: notification)
        }
    }
}

#Preview {
    NavigationView {
        NotificationDetailView(notification: Notification.examples[0])
    }
} 