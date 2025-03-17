import Foundation

@MainActor
class StorageService {
    static let shared = StorageService()
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case posts = "stored_posts"
        case hotTopics = "stored_topics"
        case columns = "stored_columns"
        case user = "stored_user"
    }
    
    private init() {}
    
    // 通用存储方法
    func save<T: Encodable>(_ value: T, for key: String) throws {
        let data = try JSONEncoder().encode(value)
        userDefaults.set(data, forKey: key)
    }
    
    // 通用加载方法
    func load<T: Decodable>(_ type: T.Type, for key: String) throws -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        return try JSONDecoder().decode(type, from: data)
    }
    
    // 特定数据类型的便捷方法
    func savePosts(_ posts: [Post]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(posts)
        userDefaults.set(data, forKey: Keys.posts.rawValue)
    }
    
    func loadPosts() -> [Post] {
        guard let data = userDefaults.data(forKey: Keys.posts.rawValue) else { return [] }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Post].self, from: data)
        } catch {
            print("Error loading posts: \(error)")
            userDefaults.removeObject(forKey: Keys.posts.rawValue)
            return []
        }
    }
    
    func saveHotTopics(_ topics: [HotTopic]) throws {
        try save(topics, for: Keys.hotTopics.rawValue)
    }
    
    func loadHotTopics() -> [HotTopic] {
        (try? load([HotTopic].self, for: Keys.hotTopics.rawValue)) ?? []
    }
    
    func saveColumns(_ columns: [Column]) throws {
        try save(columns, for: Keys.columns.rawValue)
    }
    
    func loadColumns() -> [Column] {
        (try? load([Column].self, for: Keys.columns.rawValue)) ?? []
    }
    
    // 删除数据
    func remove(for key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // 检查数据是否存在
    func exists(for key: String) -> Bool {
        userDefaults.object(forKey: key) != nil
    }
    
    // 清除所有数据
    func clearAll() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
    }
} 