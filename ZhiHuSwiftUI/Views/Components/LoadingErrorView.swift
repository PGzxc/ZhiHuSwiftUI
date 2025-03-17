import SwiftUI

struct LoadingErrorView: View {
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

#Preview {
    LoadingErrorView(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "网络连接失败"]), retryAction: {})
} 