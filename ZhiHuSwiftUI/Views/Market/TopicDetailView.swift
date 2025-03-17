import SwiftUI

struct TopicDetailView: View {
    let topic: HotTopic
    @StateObject private var viewModel: TopicDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(topic: HotTopic) {
        self.topic = topic
        _viewModel = StateObject(wrappedValue: TopicDetailViewModel(topic: topic))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // 话题信息
                    VStack(spacing: 12) {
                        Text(topic.title)
                            .font(.title)
                            .bold()
                        
                        Text(topic.description)
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 40) {
                            VStack {
                                Text("\(topic.questionsCount)")
                                    .font(.headline)
                                Text("问题")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack {
                                Text("\(topic.followersCount)")
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
                    } else if viewModel.questions.isEmpty {
                        Text("暂无相关问题")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.questions) { question in
                                QuestionCell(question: question)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("关闭") { dismiss() },
                trailing: Button(topic.isFollowing ? "已关注" : "关注") {
                    Task {
                        if topic.isFollowing {
                            await viewModel.unfollowTopic()
                        } else {
                            await viewModel.followTopic()
                        }
                    }
                }
            )
            .refreshable {
                await viewModel.fetchQuestions()
            }
            .task {
                await viewModel.fetchQuestions()
            }
        }
    }
} 