import SwiftUI

struct CreatePostView: View {
    @State private var title = ""
    @State private var content = ""
    @State private var selectedTopic: String?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("标题")) {
                    TextField("请输入标题", text: $title)
                }
                
                Section(header: Text("正文")) {
                    TextEditor(text: $content)
                        .frame(height: 200)
                }
                
                Section(header: Text("话题")) {
                    ForEach(["iOS开发", "SwiftUI", "产品设计"], id: \.self) { topic in
                        Button(topic) {
                            selectedTopic = topic
                        }
                        .foregroundColor(selectedTopic == topic ? .blue : .primary)
                    }
                }
            }
            .navigationTitle("发布")
            .navigationBarItems(
                leading: Button("取消") { dismiss() },
                trailing: Button("发布") { publishPost() }
            )
        }
    }
    
    private func publishPost() {
        // 这里添加发布逻辑
        dismiss()
    }
} 