import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ContentLoadingView()
                } else if let error = viewModel.error {
                    LoadingErrorView(error: error) {
                        Task {
                            await viewModel.fetchPosts()
                        }
                    }
                } else {
                    List {
                        ForEach(viewModel.posts) { post in
                            PostCell(post: post)
                        }
                    }
                }
            }
            .navigationTitle("首页")
            .refreshable {
                await viewModel.fetchPosts()
            }
        }
    }
}

#Preview {
    HomeView()
}
