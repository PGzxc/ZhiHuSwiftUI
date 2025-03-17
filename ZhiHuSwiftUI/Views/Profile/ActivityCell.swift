import SwiftUI

struct ActivityCell: View {
    let activity: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 活动类型标签
            HStack {
                Text("发布了文章")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(formatDate(activity.timestamp))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // 文章内容预览
            VStack(alignment: .leading, spacing: 8) {
                Text(activity.title)
                    .font(.headline)
                
                Text(activity.content)
                    .font(.body)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
            }
            
            // 互动数据
            HStack(spacing: 16) {
                Label("\(activity.upvotes)", systemImage: "hand.thumbsup")
                Label("\(activity.comments)", systemImage: "text.bubble")
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// 预览
struct ActivityCell_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCell(activity: Post.example)
            .previewLayout(.sizeThatFits)
    }
} 