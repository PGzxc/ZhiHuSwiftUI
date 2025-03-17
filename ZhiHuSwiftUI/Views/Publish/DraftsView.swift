import SwiftUI

struct DraftsView: View {
    @StateObject private var viewModel = DraftsViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State private var draftToDelete: Draft?
    @Binding var selectedDraftId: String?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.drafts) { draft in
                    Button {
                        selectedDraftId = draft.id
                        dismiss()
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(draft.title.isEmpty ? "无标题" : draft.title)
                                .font(.headline)
                            
                            Text(draft.richText.text.isEmpty ? "无内容" : draft.richText.text)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                            
                            Text(draft.lastModified, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            draftToDelete = draft
                            showingDeleteAlert = true
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("草稿箱")
            .navigationBarItems(trailing: Button("完成") { dismiss() })
            .alert("删除草稿", isPresented: $showingDeleteAlert) {
                Button("取消", role: .cancel) {}
                Button("删除", role: .destructive) {
                    if let draft = draftToDelete {
                        viewModel.deleteDraft(draft)
                    }
                }
            } message: {
                Text("确定要删除这篇草稿吗？此操作不可撤销。")
            }
            .refreshable {
                await viewModel.loadDrafts()
            }
            .task {
                await viewModel.loadDrafts()
            }
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