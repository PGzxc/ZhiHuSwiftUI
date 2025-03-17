import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("出错了")
                .font(.title)
            
            Text(error.localizedDescription)
                .foregroundColor(.gray)
            
            Button("重试") {
                retryAction()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
} 