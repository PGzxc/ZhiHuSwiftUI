import Foundation
import Combine

@MainActor
class ColumnDetailViewModel: ObservableObject {
    @Published private(set) var articles: [Article] = []
    @Published private(set) var isLoading = false
    @Published var error: Error?
    @Published var column: Column
    
    init(column: Column) {
        self.column = column
    }
    
    func fetchArticles() async {
        isLoading = true
        error = nil
        
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            articles = [Article.example]
            #else
            articles = try await NetworkService.shared.fetch(.columnArticles(column.id))
            #endif
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func followColumn() async {
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            column.isFollowing = true
            #else
            try await NetworkService.shared.post(.followColumn(column.id), body: EmptyBody())
            column.isFollowing = true
            #endif
        } catch {
            self.error = error
        }
    }
    
    func unfollowColumn() async {
        do {
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            column.isFollowing = false
            #else
            try await NetworkService.shared.post(.unfollowColumn(column.id), body: EmptyBody())
            column.isFollowing = false
            #endif
        } catch {
            self.error = error
        }
    }
} 