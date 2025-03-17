import Foundation

@MainActor
class DraftsViewModel: ObservableObject {
    @Published private(set) var drafts: [Draft] = []
    @Published var error: Error?
    
    private let draftService = DraftService.shared
    
    func loadDrafts() async {
        do {
            drafts = try draftService.loadDrafts()
                .sorted { $0.lastModified > $1.lastModified }
        } catch {
            self.error = error
        }
    }
    
    func deleteDraft(_ draft: Draft) {
        do {
            try draftService.deleteDraft(id: draft.id)
            drafts.removeAll { $0.id == draft.id }
        } catch {
            self.error = error
        }
    }
} 