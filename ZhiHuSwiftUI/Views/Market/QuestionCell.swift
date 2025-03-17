import SwiftUI

struct QuestionCell: View {
    let question: Question
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(question.title)
                .font(.headline)
            
            Text(question.content)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            HStack {
                HStack(spacing: 4) {
                    AsyncImage(url: URL(string: question.author.avatar)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    
                    Text(question.author.name)
                }
                .font(.caption)
                
                Spacer()
                
                Label("\(question.answersCount)", systemImage: "text.bubble")
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
    QuestionCell(question: Question.example)
} 