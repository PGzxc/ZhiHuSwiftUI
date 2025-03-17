import SwiftUI

struct ArticleCell: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(article.title)
                .font(.headline)
            
            Text(article.summary)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            HStack {
                HStack(spacing: 4) {
                    AsyncImage(url: URL(string: article.author.avatar)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    
                    Text(article.author.name)
                }
                .font(.caption)
                
                Spacer()
                
                Label("\(article.readCount)", systemImage: "eye")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Label("\(article.likesCount)", systemImage: "hand.thumbsup")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    ArticleCell(article: Article.example)
} 