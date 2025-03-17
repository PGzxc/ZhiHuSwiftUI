import SwiftUI
import PhotosUI

@MainActor
class PublishViewModel: ObservableObject {
    @Published var title = ""
    @Published var content = ""
    @Published var selectedImages: [UIImage] = []
    @Published var selectedTopics: [HotTopic] = []
    @Published var mentionedUsers: [User] = []
    
    @Published var imageSelection: [PhotosPickerItem] = [] {
        didSet {
            Task {
                await loadImages()
            }
        }
    }
    
    @Published var showingTopicPicker = false
    @Published var showingMentionPicker = false
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    @Published var richText = RichText(text: "", attributes: [])
    @Published var selectedRange: Range<Int>?
    @Published var showingFormatMenu = false
    
    // 发布设置
    @Published var visibility = Visibility.public
    @Published var commentSetting = CommentSetting.all
    @Published var showingSettings = false
    
    @Published var showingDrafts = false
    
    private var draftId: String?
    private var autoSaveTask: Task<Void, Never>?
    private let draftService = DraftService.shared
    
    init(draftId: String? = nil) {
        self.draftId = draftId
        if let draftId = draftId {
            loadDraft(id: draftId)
        }
        setupAutoSave()
    }
    
    private func setupAutoSave() {
        // 每30秒自动保存一次
        autoSaveTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 30_000_000_000)
                await saveDraft()
            }
        }
    }
    
    deinit {
        autoSaveTask?.cancel()
    }
    
    func saveDraft() {
        guard !title.isEmpty || !richText.text.isEmpty else { return }
        
        let draft = Draft(
            id: draftId ?? UUID().uuidString,
            title: title,
            richText: richText,
            images: selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) },
            topics: selectedTopics,
            mentions: mentionedUsers
        )
        
        do {
            try draftService.saveDraft(draft)
            draftId = draft.id
        } catch {
            self.error = error
        }
    }
    
    func loadDraft(id: String) {
        do {
            guard let draft = try draftService.loadDraft(id: id) else { return }
            
            title = draft.title
            richText = draft.richText
            selectedImages = draft.images.compactMap { UIImage(data: $0) }
            selectedTopics = draft.topics
            mentionedUsers = draft.mentions
        } catch {
            self.error = error
        }
    }
    
    func deleteDraft() {
        guard let id = draftId else { return }
        do {
            try draftService.deleteDraft(id: id)
            draftId = nil
        } catch {
            self.error = error
        }
    }
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        content.count <= 2000
    }
    
    private func loadImages() async {
        for item in imageSelection {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                await MainActor.run {
                    selectedImages.append(image)
                }
            }
        }
    }
    
    func removeImage(at index: Int) {
        selectedImages.remove(at: index)
        imageSelection.remove(at: index)
    }
    
    // 格式化操作
    func toggleBold() {
        guard let range = selectedRange else { return }
        if hasAttribute(.bold, in: range) {
            removeAttribute(.bold, in: range)
        } else {
            addAttribute(.bold, in: range)
        }
    }
    
    func toggleItalic() {
        guard let range = selectedRange else { return }
        if hasAttribute(.italic, in: range) {
            removeAttribute(.italic, in: range)
        } else {
            addAttribute(.italic, in: range)
        }
    }
    
    func addLink(_ url: String) {
        guard let range = selectedRange else { return }
        addAttribute(.link, in: range, data: .link(url: url))
    }
    
    private func stringRange(from range: Range<Int>) -> Range<String.Index> {
        let startIndex = richText.text.index(richText.text.startIndex, offsetBy: range.lowerBound)
        let endIndex = richText.text.index(richText.text.startIndex, offsetBy: range.upperBound)
        return startIndex..<endIndex
    }
    
    func addMention(_ user: User) {
        guard let range = selectedRange else { return }
        addAttribute(.mention, in: range, data: .mention(userId: user.id))
        richText.text.replaceSubrange(stringRange(from: range), with: "@\(user.name)")
    }
    
    func addTopic(_ topic: HotTopic) {
        guard let range = selectedRange else { return }
        addAttribute(.topic, in: range, data: .topic(topicId: topic.id))
        richText.text.replaceSubrange(stringRange(from: range), with: "#\(topic.title)#")
    }
    
    // 属性管理
    private func addAttribute(_ type: RichText.Attribute.AttributeType, in range: Range<Int>, data: RichText.Attribute.AttributeData? = nil) {
        richText.attributes.append(RichText.Attribute(range: range, type: type, data: data))
        objectWillChange.send()
    }
    
    private func removeAttribute(_ type: RichText.Attribute.AttributeType, in range: Range<Int>) {
        richText.attributes.removeAll { attribute in
            attribute.type == type && attribute.range == range
        }
        objectWillChange.send()
    }
    
    private func hasAttribute(_ type: RichText.Attribute.AttributeType, in range: Range<Int>) -> Bool {
        richText.attributes.contains { attribute in
            attribute.type == type && attribute.range == range
        }
    }
    
    // 发布设置枚举
    enum Visibility: String, CaseIterable, Codable {
        case `public` = "public"
        case followers = "followers"
        case `private` = "private"
        
        var title: String {
            switch self {
            case .public: return "公开"
            case .followers: return "仅关注者可见"
            case .private: return "仅自己可见"
            }
        }
        
        var icon: String {
            switch self {
            case .public: return "globe"
            case .followers: return "person.2"
            case .private: return "lock"
            }
        }
    }
    
    enum CommentSetting: String, CaseIterable, Codable {
        case all = "all"
        case followers = "followers"
        case none = "none"
        
        var title: String {
            switch self {
            case .all: return "所有人可评论"
            case .followers: return "仅关注者可评论"
            case .none: return "禁止评论"
            }
        }
        
        var icon: String {
            switch self {
            case .all: return "message"
            case .followers: return "person.2.circle"
            case .none: return "slash.circle"
            }
        }
    }
    
    // 更新 PublishRequest 结构体
    private struct PublishRequest: Codable {
        let title: String
        let content: RichText
        let images: [String]
        let topics: [String]
        let mentions: [String]
        let visibility: Visibility
        let commentSetting: CommentSetting
        
        private enum CodingKeys: String, CodingKey {
            case title
            case content
            case images
            case topics = "topic_ids"
            case mentions = "mention_ids"
            case visibility
            case commentSetting = "comment_setting"
        }
    }
    
    // 更新 publish 方法
    func publish() async -> Bool {
        guard isValid else { return false }
        
        isLoading = true
        error = nil
        
        do {
            // 1. 上传图片
            var imageUrls: [String] = []
            for image in selectedImages {
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    let imageUrl = try await uploadImage(imageData)
                    imageUrls.append(imageUrl)
                }
            }
            
            // 2. 发布帖子
            let request = PublishRequest(
                title: title,
                content: richText,
                images: imageUrls,
                topics: selectedTopics.map { $0.id },
                mentions: mentionedUsers.map { $0.id },
                visibility: visibility,
                commentSetting: commentSetting
            )
            
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            #else
            let response: PublishResponse = try await NetworkService.shared.post(
                .createPost,
                body: request
            )
            #endif
            
            // 3. 发布成功后删除草稿
            if let id = draftId {
                try draftService.deleteDraft(id: id)
            }
            
            // 4. 重置状态
            resetState()
            
            isLoading = false
            return true
            
        } catch {
            self.error = error
            isLoading = false
            return false
        }
    }
    
    // 上传单个图片
    private func uploadImage(_ imageData: Data) async throws -> String {
        #if DEBUG
        return "https://example.com/image.jpg"
        #else
        let response: [String: String] = try await NetworkService.shared.upload(
            .uploadImage,
            data: imageData,
            mimeType: "image/jpeg"
        )
        return response["url"] ?? ""
        #endif
    }
    
    // 重置状态
    private func resetState() {
        title = ""
        richText = RichText(text: "", attributes: [])
        selectedImages = []
        selectedTopics = []
        mentionedUsers = []
        imageSelection = []
        content = ""
        draftId = nil
        visibility = .public
        commentSetting = .all
    }
} 