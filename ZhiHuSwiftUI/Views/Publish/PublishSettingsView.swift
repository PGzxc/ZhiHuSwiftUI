import SwiftUI

struct PublishSettingsView: View {
    @ObservedObject var viewModel: PublishViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("可见性") {
                    ForEach(PublishViewModel.Visibility.allCases, id: \.self) { visibility in
                        Button {
                            viewModel.visibility = visibility
                        } label: {
                            HStack {
                                Label(visibility.title, systemImage: visibility.icon)
                                    .foregroundColor(.primary)
                                Spacer()
                                if viewModel.visibility == visibility {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                Section("评论设置") {
                    ForEach(PublishViewModel.CommentSetting.allCases, id: \.self) { setting in
                        Button {
                            viewModel.commentSetting = setting
                        } label: {
                            HStack {
                                Label(setting.title, systemImage: setting.icon)
                                    .foregroundColor(.primary)
                                Spacer()
                                if viewModel.commentSetting == setting {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("发布设置")
            .navigationBarItems(trailing: Button("完成") { dismiss() })
        }
    }
} 