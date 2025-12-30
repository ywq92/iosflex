import SwiftUI

struct AppListView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0 // 0: All, 1: User, 2: System
    @StateObject private var appManager = AppManager.shared
    
    var filteredApps: [InstalledApp] {
        let filteredByType = appManager.apps.filter { app in
            if selectedTab == 1 { return !app.isSystem }
            if selectedTab == 2 { return app.isSystem }
            return true
        }
        
        if searchText.isEmpty {
            return filteredByType
        } else {
            return filteredByType.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.bundleId.localizedCaseInsensitiveContains(searchText) }
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
                
                if appManager.isLoading {
                    ProgressView("加载应用列表中...")
                } else {
                    List(filteredApps) { app in
                        // Pass the selected app to ClassBrowserView first, mimicking Flex3 flow
                        NavigationLink(destination: ClassBrowserView(targetApp: app)) {
                            HStack(spacing: 12) {
                                // Placeholder Icon with randomized colors for better visuals
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(app.isSystem ? Color.gray.opacity(0.8) : Color.blue)
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: app.isSystem ? "gear" : "app.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(app.name)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Text(app.bundleId)
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if app.isSystem {
                                    Text("SYSTEM")
                                        .font(.system(size: 10, weight: .bold))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.gray.opacity(0.15))
                                        .foregroundColor(.gray)
                                        .cornerRadius(4)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(InsetGroupedListStyle()) // Modern list style
                }
            }
            .navigationTitle("应用列表")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onAppear {
                if appManager.apps.isEmpty {
                    appManager.fetchApps()
                }
            }
            .refreshable {
                appManager.fetchApps()
            }
        }
    }
}
