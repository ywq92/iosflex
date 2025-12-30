import Foundation
import UIKit
import ObjectiveC

struct InstalledApp: Identifiable {
    let id = UUID()
    let name: String
    let bundleId: String
    let isSystem: Bool
    // Icon loading is complex without public APIs, we will use a placeholder for now or try to fetch it
}

class AppManager: ObservableObject {
    @Published var apps: [InstalledApp] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    static let shared = AppManager()
    
    func fetchApps() {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            var fetchedApps: [InstalledApp] = []
            
            // Get LSApplicationWorkspace class
            guard let workspaceClass = NSClassFromString("LSApplicationWorkspace") as? NSObject.Type else {
                DispatchQueue.main.async {
                    self.errorMessage = "错误: 无法加载 LSApplicationWorkspace (系统组件缺失)"
                    self.isLoading = false
                }
                return
            }
            
            // Get defaultWorkspace instance
            let selector = NSSelectorFromString("defaultWorkspace")
            guard let workspace = workspaceClass.perform(selector)?.takeUnretainedValue() as? NSObject else {
                DispatchQueue.main.async {
                    self.errorMessage = "错误: 无法获取 defaultWorkspace"
                    self.isLoading = false
                }
                return
            }
            
            // Get allInstalledApplications
            let allAppsSelector = NSSelectorFromString("allInstalledApplications")
            guard let proxies = workspace.perform(allAppsSelector)?.takeUnretainedValue() as? [NSObject] else {
                DispatchQueue.main.async {
                    self.errorMessage = "错误: 无法获取应用列表 (可能是权限不足，请确保使用巨魔安装并拥有 entitlements)"
                    self.isLoading = false
                }
                return
            }
            
            for proxy in proxies {
                // Get name (localizedName)
                let nameSelector = NSSelectorFromString("localizedName")
                let name = proxy.perform(nameSelector)?.takeUnretainedValue() as? String ?? "Unknown"
                
                // Get bundle ID (applicationIdentifier)
                let idSelector = NSSelectorFromString("applicationIdentifier")
                let bundleId = proxy.perform(idSelector)?.takeUnretainedValue() as? String ?? ""
                
                // Get application type (applicationType) - "User" or "System"
                let typeSelector = NSSelectorFromString("applicationType")
                let type = proxy.perform(typeSelector)?.takeUnretainedValue() as? String
                let isSystem = type != "User"
                
                // Filter out some internal hidden apps if needed
                if !bundleId.isEmpty {
                    fetchedApps.append(InstalledApp(name: name, bundleId: bundleId, isSystem: isSystem))
                }
            }
            
            DispatchQueue.main.async {
                self.apps = fetchedApps.sorted { $0.name < $1.name }
                self.isLoading = false
                
                if self.apps.isEmpty {
                    self.errorMessage = "未找到任何应用 (请检查应用签名权限)"
                }
            }
        }
    }
}
