import SwiftUI

struct ColumnDetailView: View {
    let column: Column
    @StateObject private var viewModel: ColumnDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(column: Column) {
        self.column = column
        _viewModel = StateObject(wrappedValue: ColumnDetailViewModel(column: column))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // 专栏信息
                    VStack(spacing: 12) {
                        AsyncImage(url: URL(string: column.image)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        Text(column.title)
                            .font(.title2)
                            .bold()
                        
                        Text(column.description)
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Text("作者：\(column.author)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 40) {
                            VStack {
                                Text("\(column.articlesCount)")
                                    .font(.headline)
                                Text("文章")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack {
                                Text("\(column.followersCount)")
                                    .font(.headline)
                                Text("关注者")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    
                    if viewModel.isLoading {
                        ContentLoadingView()
                    } else if viewModel.articles.isEmpty {
                        Text("暂无文章")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.articles) { article in
                                ArticleCell(article: article)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("关闭") { dismiss() },
                trailing: Button(column.isFollowing ? "已关注" : "关注") {
                    Task {
                        if column.isFollowing {
                            await viewModel.unfollowColumn()
                        } else {
                            await viewModel.followColumn()
                        }
                    }
                }
            )
            .refreshable {
                await viewModel.fetchArticles()
            }
            .task {
                await viewModel.fetchArticles()
            }
        }
    }
} 