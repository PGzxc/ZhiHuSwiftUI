import Foundation

@MainActor
class MarketViewModel: ObservableObject {
    @Published private(set) var hotTopics: [HotTopic] = []
    @Published private(set) var columns: [Column] = []
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let storage = StorageService.shared
    
    init() {
        loadLocalData()
        Task {
            await fetchData()
        }
    }
    
    private func loadLocalData() {
        hotTopics = storage.loadHotTopics()
        columns = storage.loadColumns()
    }
    
    func fetchData() async {
        isLoading = true
        error = nil
        
        do {
            async let topicsTask: [HotTopic] = fetchHotTopics()
            async let columnsTask: [Column] = fetchColumns()
            
            let (topics, columns) = try await (topicsTask, columnsTask)
            
            // 保存到本地存储
            try storage.saveHotTopics(topics)
            try storage.saveColumns(columns)
            
            self.hotTopics = topics
            self.columns = columns
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    private func fetchHotTopics() async throws -> [HotTopic] {
        #if DEBUG
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return HotTopic.examples
        #else
        return try await NetworkService.shared.get(.topics)
        #endif
    }
    
    private func fetchColumns() async throws -> [Column] {
        #if DEBUG
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return Column.examples
        #else
        return try await NetworkService.shared.get(.columns)
        #endif
    }
    
    func refreshData() async {
        do {
            async let topicsTask: [HotTopic] = fetchHotTopics()
            async let columnsTask: [Column] = fetchColumns()
            
            let (topics, columns) = try await (topicsTask, columnsTask)
            
            try storage.saveHotTopics(topics)
            try storage.saveColumns(columns)
            
            self.hotTopics = topics
            self.columns = columns
        } catch {
            self.error = error
        }
    }
    
    // 定义请求体类型
    private struct EmptyBody: Codable {}
    
    // 定义响应类型
    private struct EmptyResponse: Codable {}
    
    func followTopic(_ topic: HotTopic) async {
        do {
            let _: EmptyBody = try await NetworkService.shared.post(
                .followTopic(topic.id),
                body: EmptyBody()
            )
            if let index = hotTopics.firstIndex(where: { $0.id == topic.id }) {
                var updatedTopic = hotTopics[index]
                updatedTopic.isFollowing = true
                hotTopics[index] = updatedTopic
                try storage.saveHotTopics(hotTopics)
            }
        } catch {
            self.error = error
        }
    }
    
    func unfollowTopic(_ topic: HotTopic) async {
        do {
            let _: EmptyBody = try await NetworkService.shared.post(
                .unfollowTopic(topic.id),
                body: EmptyBody()
            )
            if let index = hotTopics.firstIndex(where: { $0.id == topic.id }) {
                var updatedTopic = hotTopics[index]
                updatedTopic.isFollowing = false
                hotTopics[index] = updatedTopic
                try storage.saveHotTopics(hotTopics)
            }
        } catch {
            self.error = error
        }
    }
    
    func followColumn(_ column: Column) async {
        do {
            let _: EmptyBody = try await NetworkService.shared.post(
                .followColumn(column.id),
                body: EmptyBody()
            )
            if let index = columns.firstIndex(where: { $0.id == column.id }) {
                var updatedColumn = columns[index]
                updatedColumn.isFollowing = true
                columns[index] = updatedColumn
                try storage.saveColumns(columns)
            }
        } catch {
            self.error = error
        }
    }
    
    func unfollowColumn(_ column: Column) async {
        do {
            let _: EmptyBody = try await NetworkService.shared.post(
                .unfollowColumn(column.id),
                body: EmptyBody()
            )
            if let index = columns.firstIndex(where: { $0.id == column.id }) {
                var updatedColumn = columns[index]
                updatedColumn.isFollowing = false
                columns[index] = updatedColumn
                try storage.saveColumns(columns)
            }
        } catch {
            self.error = error
        }
    }
} 