import SwiftUI

struct ContentLoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("加载中...")
                .foregroundColor(.gray)
                .padding(.top, 8)
        }
    }
}

#Preview {
    ContentLoadingView()
} 