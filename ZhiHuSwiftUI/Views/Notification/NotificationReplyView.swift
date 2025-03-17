import SwiftUI

struct NotificationReplyView: View {
    let notification: Notification
    @StateObject private var viewModel: NotificationReplyViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var replyText = ""
    @FocusState private var isFocused: Bool
    
    init(notification: Notification) {
        self.notification = notification
        _viewModel = StateObject(wrappedValue: NotificationReplyViewModel(notification: notification))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 回复预览
                VStack(alignment: .leading, spacing: 12) {
                    // 原内容
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: notification.sender.avatar)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(notification.sender.name)
                                .font(.headline)
                            if let comment = notification.relatedComment {
                                Text(comment)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                
                Divider()
                
                // 回复输入框
                VStack(spacing: 16) {
                    TextEditor(text: $replyText)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .focused($isFocused)
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("回复")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") { dismiss() },
                trailing: Button("发布") {
                    Task {
                        await viewModel.submitReply(content: replyText)
                        dismiss()
                    }
                }
                .disabled(replyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
            )
            .alert("错误", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Button("确定", role: .cancel) {}
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
            .onAppear {
                isFocused = true
            }
        }
    }
} 