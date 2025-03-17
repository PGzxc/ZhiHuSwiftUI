import SwiftUI

@MainActor
class ProfileEditViewModel: ObservableObject {
    @Published var name: String
    @Published var headline: String
    @Published var avatar: String
    @Published var gender: Gender
    @Published var location: String
    @Published var occupation: String
    @Published var bio: String
    
    @Published var selectedImage: UIImage?
    @Published var showingImagePicker = false
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let user: User
    
    init(user: User) {
        self.user = user
        self.name = user.name
        self.headline = user.headline
        self.avatar = user.avatar
        self.gender = .other  // 从用户数据获取
        self.location = ""    // 从用户数据获取
        self.occupation = ""  // 从用户数据获取
        self.bio = ""        // 从用户数据获取
    }
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !headline.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func saveProfile() async -> Bool {
        isLoading = true
        error = nil
        
        do {
            // 如果有新头像，先上传图片
            if let image = selectedImage {
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    throw ProfileError.unknown
                }
                
                #if DEBUG
                try await Task.sleep(nanoseconds: 1_000_000_000)
                avatar = "new_avatar_url"
                #else
                let response: [String: String] = try await NetworkService.shared.upload(
                    .uploadAvatar,
                    data: imageData,
                    mimeType: "image/jpeg"
                )
                avatar = response["url"] ?? avatar
                #endif
            }
            
            #if DEBUG
            try await Task.sleep(nanoseconds: 1_000_000_000)
            #else
            try await NetworkService.shared.post(
                .updateProfile,
                body: [
                    "name": name,
                    "headline": headline,
                    "avatar": avatar,
                    "gender": gender.rawValue,
                    "location": location,
                    "occupation": occupation,
                    "bio": bio
                ]
            )
            #endif
            
            isLoading = false
            return true
        } catch {
            self.error = error
            isLoading = false
            return false
        }
    }
} 
