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
                        NavigationLink(destination: PatchEditorView(targetApp: app)) {
                            HStack {
                                // Placeholder Icon
                                Image(systemName: app.isSystem ? "gear" : "app.fill")
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
                                
                                if app.isSystem {
                                    Text("System")
                                        .font(.caption2)
                                        .padding(4)
                                        .background(Color.gray.opacity(0.2))
                                        .foregroundColor(.gray)
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
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
