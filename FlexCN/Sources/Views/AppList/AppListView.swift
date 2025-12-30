import SwiftUI

struct AppListView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0 // 0: All, 1: User, 2: System
    
    // Mock Data
    struct AppInfo: Identifiable {
        let id = UUID()
        let name: String
        let bundleId: String
        let icon: String // System image name for mock
        let isSystem: Bool
        let isRunning: Bool
    }
    
    let apps = [
        AppInfo(name: "微信", bundleId: "com.tencent.xin", icon: "message.fill", isSystem: false, isRunning: true),
        AppInfo(name: "设置", bundleId: "com.apple.Preferences", icon: "gear", isSystem: true, isRunning: false),
        AppInfo(name: "Safari", bundleId: "com.apple.mobilesafari", icon: "safari", isSystem: true, isRunning: true)
    ]
    
    var filteredApps: [AppInfo] {
        let filteredByType = apps.filter { app in
            if selectedTab == 1 { return !app.isSystem }
            if selectedTab == 2 { return app.isSystem }
            return true
        }
        
        if searchText.isEmpty {
            return filteredByType
        } else {
            return filteredByType.filter { $0.name.contains(searchText) || $0.bundleId.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("分类", selection: $selectedTab) {
                    Text("全部").tag(0)
                    Text("用户应用").tag(1)
                    Text("系统应用").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List(filteredApps) { app in
                    HStack {
                        Image(systemName: app.icon)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(app.name)
                                .font(.headline)
                            Text(app.bundleId)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        if app.isRunning {
                            Text("运行中")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(4)
                        }
                        
                        Button(action: {
                            // Action to inject or open settings
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("应用列表")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}
