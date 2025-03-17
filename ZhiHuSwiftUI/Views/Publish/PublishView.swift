import SwiftUI
import PhotosUI

struct PublishView: View {
    @StateObject private var viewModel: PublishViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDraftId: String?
    
    init(draftId: String? = nil) {
        _viewModel = StateObject(wrappedValue: PublishViewModel(draftId: draftId))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    titleField
                    Divider()
                    richTextEditor
                    imageGallery
                    toolbar
                }
            }
            .navigationTitle("发布文章")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: leadingButtons, trailing: trailingButtons)
            .sheet(isPresented: $viewModel.showingTopicPicker) {
                TopicPickerView(selectedTopics: $viewModel.selectedTopics)
            }
            .sheet(isPresented: $viewModel.showingMentionPicker) {
                MentionPickerView(selectedUsers: $viewModel.mentionedUsers)
            }
            .sheet(isPresented: $viewModel.showingDrafts) {
                DraftsView(selectedDraftId: $selectedDraftId)
            }
            .sheet(isPresented: $viewModel.showingSettings) {
                PublishSettingsView(viewModel: viewModel)
            }
            .onChange(of: selectedDraftId) { newValue in
                if let draftId = newValue {
                    viewModel.loadDraft(id: draftId)
                    selectedDraftId = nil
                }
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
                    loadingOverlay
                }
            }
            .popover(
                isPresented: Binding(
                    get: { viewModel.showingFormatMenu },
                    set: { viewModel.showingFormatMenu = $0 }
                )
            ) {
                FormatMenu(viewModel: viewModel)
            }
        }
    }
    
    private var titleField: some View {
        TextField("标题", text: $viewModel.title)
            .font(.title2.bold())
            .padding(.horizontal)
    }
    
    private var richTextEditor: some View {
        RichTextEditor(
            text: $viewModel.richText.text,
            attributes: $viewModel.richText.attributes,
            selectedRange: $viewModel.selectedRange
        ) {
            viewModel.showingFormatMenu = true
        }
        .padding(.horizontal)
    }
    
    private var imageGallery: some View {
        Group {
            if !viewModel.selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.selectedImages.indices, id: \.self) { index in
                            imageCell(at: index)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private func imageCell(at index: Int) -> some View {
        Image(uiImage: viewModel.selectedImages[index])
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                deleteButton(for: index),
                alignment: .topTrailing
            )
    }
    
    private func deleteButton(for index: Int) -> some View {
        Button {
            viewModel.removeImage(at: index)
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.white)
                .padding(4)
        }
        .background(Color.black.opacity(0.6))
        .clipShape(Circle())
        .padding(4)
    }
    
    private var toolbar: some View {
        HStack {
            PhotosPicker(
                selection: $viewModel.imageSelection,
                maxSelectionCount: 9,
                matching: .images
            ) {
                Image(systemName: "photo")
                    .font(.title2)
            }
            
            Button {
                viewModel.showingTopicPicker = true
            } label: {
                Image(systemName: "number")
                    .font(.title2)
            }
            
            Button {
                viewModel.showingMentionPicker = true
            } label: {
                Image(systemName: "at")
                    .font(.title2)
            }
            
            Spacer()
            
            Text("\(viewModel.content.count)/2000")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    private var leadingButtons: some View {
        HStack {
            Button("取消") { dismiss() }
            Button("草稿箱") { viewModel.showingDrafts = true }
        }
    }
    
    private var trailingButtons: some View {
        HStack {
            Button {
                viewModel.showingSettings = true
            } label: {
                Image(systemName: "gearshape")
            }
            
            Button("发布") {
                Task {
                    if await viewModel.publish() {
                        dismiss()
                    }
                }
            }
            .disabled(!viewModel.isValid)
        }
    }
    
    private var loadingOverlay: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.2))
    }
}

// 话题选择器
struct TopicPickerView: View {
    @Binding var selectedTopics: [HotTopic]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(HotTopic.examples, id: \.id) { topic in
                Button {
                    if selectedTopics.contains(where: { $0.id == topic.id }) {
                        selectedTopics.removeAll { $0.id == topic.id }
                    } else {
                        selectedTopics.append(topic)
                    }
                } label: {
                    HStack {
                        Text(topic.title)
                        Spacer()
                        if selectedTopics.contains(where: { $0.id == topic.id }) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("选择话题")
            .navigationBarItems(trailing: Button("完成") { dismiss() })
        }
    }
}

// 提醒用户选择器
struct MentionPickerView: View {
    @Binding var selectedUsers: [User]
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return User.examples
        }
        return User.examples.filter { user in
            user.name.localizedCaseInsensitiveContains(searchText) ||
            user.headline.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredUsers) { user in
                Button {
                    if selectedUsers.contains(where: { $0.id == user.id }) {
                        selectedUsers.removeAll { $0.id == user.id }
                    } else {
                        selectedUsers.append(user)
                    }
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: user.avatar)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            Text(user.headline)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        if selectedUsers.contains(where: { $0.id == user.id }) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "搜索用户")
            .navigationTitle("提醒谁看")
            .navigationBarItems(trailing: Button("完成") { dismiss() })
        }
    }
}

// 格式化菜单
struct FormatMenu: View {
    @ObservedObject var viewModel: PublishViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var linkURL = ""
    
    var body: some View {
        List {
            Button {
                viewModel.toggleBold()
                dismiss()
            } label: {
                Label("加粗", systemImage: "bold")
            }
            
            Button {
                viewModel.toggleItalic()
                dismiss()
            } label: {
                Label("斜体", systemImage: "italic")
            }
            
            Button {
                viewModel.showingTopicPicker = true
                dismiss()
            } label: {
                Label("添加话题", systemImage: "number")
            }
            
            Button {
                viewModel.showingMentionPicker = true
                dismiss()
            } label: {
                Label("提醒他人", systemImage: "at")
            }
            
            Section("添加链接") {
                TextField("输入链接", text: $linkURL)
                Button("确定") {
                    if !linkURL.isEmpty {
                        viewModel.addLink(linkURL)
                    }
                    dismiss()
                }
            }
        }
    }
} 