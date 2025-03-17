import SwiftUI

struct PostCell: View {
    let post: Post
    
    var body: some View {
        NavigationLink(destination: PostDetailView(postId: post.id)) {
            VStack(alignment: .leading, spacing: 12) {
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
                }
                
                // 标题
                Text(post.title)
                    .font(.title3)
                    .bold()
                    .lineLimit(2)
                
                // 内容预览
                Text(post.content)
                    .font(.body)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                // 互动信息
                HStack(spacing: 16) {
                    Label("\(post.upvotes)", systemImage: "hand.thumbsup")
                    Label("\(post.comments)", systemImage: "text.bubble")
                    Spacer()
                    Text(post.timestamp, style: .relative)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        PostCell(post: Post.example)
    }
} 