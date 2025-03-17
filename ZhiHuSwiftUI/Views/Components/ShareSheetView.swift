import SwiftUI

struct ShareSheetView: View {
    let content: ShareContent
    @Environment(\.dismiss) private var dismiss
    @State private var selectedText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 预览卡片
                VStack(alignment: .leading, spacing: 12) {
                    Text(content.title)
                        .font(.headline)
                    
                    Text(content.content)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                    
                    HStack {
                        Text("作者：\(content.author)")
                            .font(.caption)
                        Spacer()
                        Text(content.url.absoluteString)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // 分享选项
                ScrollView {
                    VStack(spacing: 16) {
                        // 复制链接
                        ShareButton(
                            title: "复制链接",
                            icon: "link",
                            color: .blue
                        ) {
                            UIPasteboard.general.string = content.url.absoluteString
                        }
                        
                        // 复制标题
                        ShareButton(
                            title: "复制标题",
                            icon: "doc.on.doc",
                            color: .orange
                        ) {
                            UIPasteboard.general.string = content.title
                        }
                        
                        // 系统分享
                        ShareButton(
                            title: "更多分享",
                            icon: "square.and.arrow.up",
                            color: .green
                        ) {
                            let items: [Any] = [
                                content.title,
                                content.url
                            ]
                            let activityVC = UIActivityViewController(
                                activityItems: items,
                                applicationActivities: nil
                            )
                            
                            // 获取当前的 UIWindow
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {
                                window.rootViewController?.present(activityVC, animated: true)
                            }
                        }
                        
                        // 生成分享图片
                        ShareButton(
                            title: "生成图片",
                            icon: "photo",
                            color: .purple
                        ) {
                            // TODO: 生成分享图片
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("分享")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("完成") { dismiss() }
            )
        }
    }
}

struct ShareButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
} 