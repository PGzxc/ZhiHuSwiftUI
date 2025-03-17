import SwiftUI

struct NotificationView: View {
    @StateObject private var viewModel = NotificationViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ContentLoadingView()
                } else if let error = viewModel.error {
                    LoadingErrorView(error: error) {
                        Task {
                            await viewModel.fetchNotifications()
                        }
                    }
                } else {
                    VStack(spacing: 0) {
                        // 分组选择器
                        Picker("分组方式", selection: $viewModel.groupBy) {
                            Text("按时间").tag(NotificationViewModel.GroupBy.time)
                            Text("按类型").tag(NotificationViewModel.GroupBy.type)
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        
                        // 消息类型选择器
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                NotificationTypeButton(
                                    title: "全部",
                                    icon: "bell.fill",
                                    color: .gray,
                                    isSelected: viewModel.selectedType == nil
                                ) {
                                    viewModel.selectedType = nil
                                }
                                
                                ForEach([
                                    Notification.NotificationType.like,
                                    .comment,
                                    .reply,
                                    .follow,
                                    .system
                                ], id: \.rawValue) { type in
                                    NotificationTypeButton(
                                        title: type.rawValue.capitalized,
                                        icon: type.icon,
                                        color: Color(type.color),
                                        isSelected: viewModel.selectedType == type
                                    ) {
                                        viewModel.selectedType = type
                                    }
                                }
                            }
                            .padding()
                        }
                        
                        Divider()
                        
                        // 分组列表
                        List {
                            let groups = viewModel.groupBy == .time ?
                                viewModel.timeGroupedNotifications :
                                viewModel.typeGroupedNotifications
                            
                            ForEach(groups, id: \.0) { section in
                                Section(header: Text(section.0)) {
                                    ForEach(section.1) { notification in
                                        NavigationLink {
                                            NotificationDetailView(notification: notification)
                                        } label: {
                                            NotificationCell(notification: notification)
                                        }
                                        .onAppear {
                                            if !notification.isRead {
                                                Task {
                                                    await viewModel.markAsRead(notification.id)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                    }
                }
            }
            .navigationTitle("消息")
            .navigationBarItems(
                trailing: HStack {
                    if viewModel.unreadCount > 0 {
                        Text("\(viewModel.unreadCount)条未读")
                            .font(.caption)
                            .padding(6)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    
                    Button("全部已读") {
                        Task {
                            await viewModel.markAllAsRead()
                        }
                    }
                    .disabled(viewModel.unreadCount == 0)
                }
            )
            .refreshable {
                await viewModel.fetchNotifications()
            }
        }
        .task {
            await viewModel.fetchNotifications()
        }
    }
}

struct NotificationTypeButton: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : color)
            .frame(width: 60, height: 60)
            .background(isSelected ? color : color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct NotificationCell: View {
    let notification: Notification
    let showTimestamp: Bool = true  // 可以根据需要控制是否显示时间戳
    
    var body: some View {
        HStack(spacing: 12) {
            // 发送者头像
            AsyncImage(url: URL(string: notification.sender.avatar)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                // 发送者名称和操作
                HStack {
                    Text(notification.sender.name)
                        .font(.headline)
                    Text(notification.content)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // 相关内容预览
                if let comment = notification.relatedComment {
                    Text(comment)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                // 根据分组方式决定是否显示时间戳
                if showTimestamp {
                    Text(notification.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // 未读标记
            if !notification.isRead {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 8)
    }
} 