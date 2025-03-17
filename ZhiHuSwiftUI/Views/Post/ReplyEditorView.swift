import SwiftUI

struct ReplyEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ReplyEditorViewModel
    @State private var replyText = ""
    
    init(postId: String, commentId: String, replyTo: String) {
        _viewModel = StateObject(wrappedValue: ReplyEditorViewModel(
            postId: postId,
            commentId: commentId,
            replyTo: replyTo
        ))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("回复: \(viewModel.replyTo)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                TextEditor(text: $replyText)
                    .frame(height: 120)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("写回复")
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
        }
    }
} 