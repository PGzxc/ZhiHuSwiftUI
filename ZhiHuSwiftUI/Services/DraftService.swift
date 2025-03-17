import Foundation

@MainActor
class DraftService {
    static let shared = DraftService()
    private let storage = StorageService.shared
    private let draftsKey = "saved_drafts"
    
    private init() {}
    
    func saveDraft(_ draft: Draft) throws {
        var drafts = try loadDrafts()
        if let index = drafts.firstIndex(where: { $0.id == draft.id }) {
            drafts[index] = draft
        } else {
            drafts.append(draft)
        }
        try storage.save(drafts, for: draftsKey)
    }
    
    func loadDrafts() throws -> [Draft] {
        try storage.load([Draft].self, for: draftsKey) ?? []
    }
    
    func deleteDraft(id: String) throws {
        var drafts = try loadDrafts()
        drafts.removeAll { $0.id == id }
        try storage.save(drafts, for: draftsKey)
    }
    
    func loadDraft(id: String) throws -> Draft? {
        try loadDrafts().first { $0.id == id }
    }
} 