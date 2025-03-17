import Foundation

struct UserSettings: Codable {
    var pushNotificationsEnabled: Bool
    var darkModeEnabled: Bool
    var autoPlayVideos: Bool
    var showReadingProgress: Bool
    var language: Language
    var contentFilter: ContentFilter
    
    enum Language: String, Codable, CaseIterable {
        case system = "跟随系统"
        case chinese = "简体中文"
        case english = "English"
    }
    
    enum ContentFilter: String, Codable, CaseIterable {
        case none = "无"
        case low = "低"
        case medium = "中"
        case high = "高"
    }
    
    static let `default` = UserSettings(
        pushNotificationsEnabled: true,
        darkModeEnabled: false,
        autoPlayVideos: true,
        showReadingProgress: true,
        language: .system,
        contentFilter: .medium
    )
} 