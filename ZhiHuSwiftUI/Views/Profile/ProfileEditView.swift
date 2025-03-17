import SwiftUI

struct ProfileEditView: View {
    @StateObject private var viewModel: ProfileEditViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: ProfileEditViewModel(user: user))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // 头像
                    HStack {
                        Text("头像")
                        Spacer()
                        AsyncImage(url: URL(string: viewModel.avatar)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .onTapGesture {
                            viewModel.showingImagePicker = true
                        }
                    }
                    
                    // 用户名
                    TextField("用户名", text: $viewModel.name)
                        .textContentType(.username)
                    
                    // 个人简介
                    TextField("个人简介", text: $viewModel.headline)
                }
                
                Section(header: Text("个人信息")) {
                    // 性别
                    Picker("性别", selection: $viewModel.gender) {
                        Text("男").tag(Gender.male)
                        Text("女").tag(Gender.female)
                        Text("保密").tag(Gender.other)
                    }
                    
                    // 所在地
                    TextField("所在地", text: $viewModel.location)
                    
                    // 职业
                    TextField("职业", text: $viewModel.occupation)
                }
                
                Section(header: Text("个人介绍")) {
                    TextEditor(text: $viewModel.bio)
                        .frame(height: 100)
                }
            }
            .navigationTitle("编辑资料")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") { dismiss() },
                trailing: Button("保存") {
                    Task {
                        if await viewModel.saveProfile() {
                            dismiss()
                        }
                    }
                }
                .disabled(!viewModel.isValid)
            )
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(image: $viewModel.selectedImage)
            }
            .alert("错误", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Button("确定", role: .cancel) {}
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        }
    }
}

// 性别枚举
enum Gender: String, Codable {
    case male = "male"
    case female = "female"
    case other = "other"
}

// 图片选择器
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
    }
} 