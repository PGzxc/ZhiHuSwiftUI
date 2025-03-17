import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house")
                }
            
            MarketView()
                .tabItem {
                    Label("市场", systemImage: "chart.bar")
                }
            
            CreatePostView()
                .tabItem {
                    Label("发布", systemImage: "plus.circle")
                }
            
            NotificationView()
                .tabItem {
                    Label("消息", systemImage: "bell")
                }
            
            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person")
                }
        }
        .environmentObject(authViewModel)
    }
} 