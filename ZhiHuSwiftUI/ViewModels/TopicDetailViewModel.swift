import Foundation
import Combine

@MainActor
class TopicDetailViewModel: ObservableObject {
    @Published private(set) var questions: [Question] = []
    @Published private(set) var isLoading = false
    @Published var error: Error?
    @Published var topic: HotTopic
    
    init(topic: HotTopic) {
        self.topic = topic
    }
    
    func fetchQuestions() async {
        isLoading = true
        error = nil
        
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            questions = [Question.example]
            #else
            questions = try await NetworkService.shared.fetch(.topicQuestions(topic.id))
            #endif
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func followTopic() async {
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            var updatedTopic = topic
            updatedTopic.isFollowing = true
            topic = updatedTopic
            #else
            try await NetworkService.shared.post(.followTopic(topic.id), body: EmptyBody())
            var updatedTopic = topic
            updatedTopic.isFollowing = true
            topic = updatedTopic
            #endif
        } catch {
            self.error = error
        }
    }
    
    func unfollowTopic() async {
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            var updatedTopic = topic
            updatedTopic.isFollowing = false
            topic = updatedTopic
            #else
            try await NetworkService.shared.post(.unfollowTopic(topic.id), body: EmptyBody())
            var updatedTopic = topic
            updatedTopic.isFollowing = false
            topic = updatedTopic
            #endif
        } catch {
            self.error = error
        }
    }
} 