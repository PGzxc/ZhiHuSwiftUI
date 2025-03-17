import SwiftUI

struct MarketView: View {
    @StateObject private var viewModel = MarketViewModel()
    @State private var selectedTab = 0
    @State private var showingTopicDetail = false
    @State private var selectedTopic: HotTopic?
    @State private var showingColumnDetail = false
    @State private var selectedColumn: Column?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 分段控制器
                Picker("", selection: $selectedTab) {
                    Text("热门话题").tag(0)
                    Text("专栏").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                TabView(selection: $selectedTab) {
                    // 热门话题列表
                    topicsList
                        .tag(0)
                    
                    // 专栏列表
                    columnsList
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("发现")
            .refreshable {
                await viewModel.refreshData()
            }
            .overlay {
                if viewModel.isLoading {
                    ContentLoadingView()
                }
            }
            .alert("错误", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Button("确定", role: .cancel) {}
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
            .sheet(item: $selectedTopic) { topic in
                TopicDetailView(topic: topic)
            }
            .sheet(item: $selectedColumn) { column in
                ColumnDetailView(column: column)
            }
        }
    }
    
    private var topicsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.hotTopics) { topic in
                    TopicCell(
                        topic: topic,
                        isFollowing: topic.isFollowing,
                        onFollow: {
                            Task {
                                await viewModel.followTopic(topic)
                            }
                        },
                        onUnfollow: {
                            Task {
                                await viewModel.unfollowTopic(topic)
                            }
                        }
                    )
                    .onTapGesture {
                        selectedTopic = topic
                    }
                    
                    if topic.id != viewModel.hotTopics.last?.id {
                        Divider()
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private var columnsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.columns) { column in
                    ColumnCell(
                        column: column,
                        isFollowing: column.isFollowing,
                        onFollow: {
                            Task {
                                await viewModel.followColumn(column)
                            }
                        },
                        onUnfollow: {
                            Task {
                                await viewModel.unfollowColumn(column)
                            }
                        }
                    )
                    .onTapGesture {
                        selectedColumn = column
                    }
                    
                    if column.id != viewModel.columns.last?.id {
                        Divider()
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

// 话题单元格
struct TopicCell: View {
    let topic: HotTopic
    let isFollowing: Bool
    let onFollow: () -> Void
    let onUnfollow: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text(topic.title)
                    .font(.headline)
                
                Text(topic.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 16) {
                    Label("\(topic.questionsCount)", systemImage: "text.bubble")
                    Label("\(topic.followersCount)", systemImage: "person.2")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button {
                if isFollowing {
                    onUnfollow()
                } else {
                    onFollow()
                }
            } label: {
                Text(isFollowing ? "取消关注" : "关注")
                    .font(.subheadline)
                    .foregroundColor(isFollowing ? .gray : .blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isFollowing ? Color.gray : Color.blue)
                    )
            }
        }
        .padding(.horizontal)
    }
}

// 专栏单元格
struct ColumnCell: View {
    let column: Column
    let isFollowing: Bool
    let onFollow: () -> Void
    let onUnfollow: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: column.image)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(column.title)
                    .font(.headline)
                
                Text(column.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack(spacing: 16) {
                    Label("\(column.articlesCount)", systemImage: "doc.text")
                    Label("\(column.followersCount)", systemImage: "person.2")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button {
                if isFollowing {
                    onUnfollow()
                } else {
                    onFollow()
                }
            } label: {
                Text(isFollowing ? "取消关注" : "关注")
                    .font(.subheadline)
                    .foregroundColor(isFollowing ? .gray : .blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isFollowing ? Color.gray : Color.blue)
                    )
            }
        }
        .padding(.horizontal)
    }
} 
