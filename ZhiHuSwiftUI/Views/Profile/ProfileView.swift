import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingSettingsSheet = false
    @State private var showingLoginSheet = false
    @State private var showingProfileEditor = false
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if let user = viewModel.user {
                    // 用户信息卡片
                    Section {
                        VStack(spacing: 16) {
                            // 头像
                            AsyncImage(url: URL(string: user.avatar)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            
                            // 用户名和简介
                            VStack(spacing: 8) {
                                Text(user.name)
                                    .font(.title2)
                                    .bold()
                                
                                Text(user.headline)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            // 关注数据
                            HStack(spacing: 40) {
                                VStack {
                                    Text("\(user.following)")
                                        .font(.headline)
                                    Text("关注")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                VStack {
                                    Text("\(user.followers)")
                                        .font(.headline)
                                    Text("关注者")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .onTapGesture {
                            showingProfileEditor = true
                        }
                    }
                    
                    // 功能列表
                    Section {
                        NavigationLink {
                            Text("我的收藏")
                        } label: {
                            Label("我的收藏", systemImage: "bookmark")
                        }
                        
                        NavigationLink {
                            Text("我的创作")
                        } label: {
                            Label("我的创作", systemImage: "doc.text")
                        }
                        
                        NavigationLink {
                            Text("浏览历史")
                        } label: {
                            Label("浏览历史", systemImage: "clock")
                        }
                    }
                    
                    // 其他功能
                    Section {
                        Button {
                            showingSettingsSheet = true
                        } label: {
                            Label("设置", systemImage: "gear")
                        }
                        
                        Button(role: .destructive) {
                            Task {
                                await viewModel.logout()
                            }
                        } label: {
                            Label("退出登录", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    }
                } else {
                    // 未登录状态
                    Button {
                        showingLoginSheet = true
                    } label: {
                        Text("登录/注册")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("我的")
            .refreshable {
                await viewModel.fetchUserProfile()
            }
            .sheet(isPresented: $showingSettingsSheet) {
                SettingsView(settings: $viewModel.settings)
            }
            .sheet(isPresented: $showingLoginSheet) {
                LoginView()
            }
            .sheet(isPresented: $showingProfileEditor) {
                if let user = viewModel.user {
                    ProfileEditView(user: user)
                }
            }
            .alert(viewModel.error?.errorDescription ?? "错误", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Button("确定", role: .cancel) {
                    // 如果是未授权错误，显示登录页面
                    if case .unauthorized = viewModel.error {
                        showingLoginSheet = true
                    }
                    viewModel.error = nil  // 现在可以直接设置了
                }
            } message: {
                if let error = viewModel.error {
                    Text(error.errorDescription ?? "")
                }
            }
        }
        .task {
            await viewModel.fetchUserProfile()
        }
    }
}

// 设置页面
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var settings: UserSettings
    
    var body: some View {
        NavigationView {
            Form {
                Section("通知设置") {
                    Toggle("推送通知", isOn: $settings.pushNotificationsEnabled)
                }
                
                Section("显示设置") {
                    Toggle("深色模式", isOn: $settings.darkModeEnabled)
                    Toggle("自动播放视频", isOn: $settings.autoPlayVideos)
                    Toggle("显示阅读进度", isOn: $settings.showReadingProgress)
                }
                
                Section("内容设置") {
                    Picker("语言", selection: $settings.language) {
                        ForEach(UserSettings.Language.allCases, id: \.self) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                    
                    Picker("内容过滤", selection: $settings.contentFilter) {
                        ForEach(UserSettings.ContentFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                }
                
                Section("关于") {
                    NavigationLink("隐私政策") {
                        Text("隐私政策内容")
                    }
                    NavigationLink("用户协议") {
                        Text("用户协议内容")
                    }
                    NavigationLink("版本信息") {
                        Text("Version 1.0.0")
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("完成") { dismiss() })
        }
    }
} 