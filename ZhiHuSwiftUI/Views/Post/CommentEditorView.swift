import SwiftUI

struct CommentEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CommentEditorViewModel
    @State private var commentText = ""
    
    init(postId: String) {
        _viewModel = StateObject(wrappedValue: CommentEditorViewModel(postId: postId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $commentText)
                    .frame(height: 150)
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
            .navigationTitle("写评论")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") { dismiss() },
                trailing: Button("发布") {
                    Task {
                        await viewModel.submitComment(content: commentText)
                        dismiss()
                    }
                }
                .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
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