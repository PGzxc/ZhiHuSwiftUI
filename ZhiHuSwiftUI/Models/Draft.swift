import Foundation

struct Draft: Codable, Identifiable {
    let id: String
    var title: String
    var richText: RichText
    var images: [Data]
    var topics: [HotTopic]
    var mentions: [User]
    var lastModified: Date
    
    init(
        id: String = UUID().uuidString,
        title: String,
        richText: RichText,
        images: [Data] = [],
        topics: [HotTopic] = [],
        mentions: [User] = [],
        lastModified: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.richText = richText
        self.images = images
        self.topics = topics
        self.mentions = mentions
        self.lastModified = lastModified
    }
} 