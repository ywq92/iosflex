import SwiftUI

struct ClassBrowserView: View {
    var targetApp: InstalledApp?
    @State private var searchText = ""
    
    // Mock Data Models
    struct ClassInfo: Identifiable {
        let id = UUID()
        let name: String
        let framework: String
    }
    
    // Dynamic mock data generation based on targetApp
    var classes: [ClassInfo] {
        guard let app = targetApp else {
            // Default classes if no app selected (should not happen in flow)
            return [
                ClassInfo(name: "UIView", framework: "UIKit"),
                ClassInfo(name: "NSString", framework: "Foundation")
            ]
        }
        
        if app.bundleId.contains("tencent.xin") { // WeChat
            return [
                ClassInfo(name: "MicroMessengerAppDelegate", framework: "App"),
                ClassInfo(name: "CMessageMgr", framework: "App"),
                ClassInfo(name: "WCPayLogic", framework: "App"),
                ClassInfo(name: "MMServiceCenter", framework: "App"),
                ClassInfo(name: "UIView", framework: "UIKit"),
                ClassInfo(name: "UIViewController", framework: "UIKit")
            ]
        } else if app.bundleId.contains("Preferences") { // Settings
            return [
                ClassInfo(name: "PSListController", framework: "App"),
                ClassInfo(name: "PrefsSUI", framework: "App"),
                ClassInfo(name: "UITableView", framework: "UIKit")
            ]
        } else {
            // Generic App
            return [
                ClassInfo(name: "AppDelegate", framework: "App"),
                ClassInfo(name: "SceneDelegate", framework: "App"),
                ClassInfo(name: "ViewController", framework: "App"),
                ClassInfo(name: "UserAccountManager", framework: "App"),
                ClassInfo(name: "NetworkHelper", framework: "App"),
                ClassInfo(name: "UIView", framework: "UIKit"),
                ClassInfo(name: "UIButton", framework: "UIKit")
            ]
        }
    }
    
    var filteredClasses: [String: [ClassInfo]] {
        let filtered = searchText.isEmpty ? classes : classes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        return Dictionary(grouping: filtered, by: { $0.framework })
    }
    
    var body: some View {
        List {
            if let app = targetApp {
                Section(header: Text("应用信息")) {
                    HStack {
                        Text("Bundle ID")
                        Spacer()
                        Text(app.bundleId).foregroundColor(.secondary)
                    }
                    HStack {
                        Text("可执行文件")
                        Spacer()
                        Text(app.name).foregroundColor(.secondary)
                    }
                }
            }
            
            ForEach(filteredClasses.keys.sorted(), id: \.self) { framework in
                Section(header: Text(framework)) {
                    ForEach(filteredClasses[framework]!) { cls in
                        NavigationLink(destination: MethodListView(className: cls.name, targetApp: targetApp)) {
                            Text(cls.name)
                                .font(.system(.body, design: .monospaced))
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(targetApp?.name ?? "类浏览器")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "搜索类名")
    }
}

struct MethodListView: View {
    let className: String
    var targetApp: InstalledApp?
    @State private var searchText = ""
    
    struct MethodInfo: Identifiable {
        let id = UUID()
        let name: String
        let type: String // "-" or "+"
    }
    
    // Mock methods
    var methods: [MethodInfo] {
        if className == "CMessageMgr" {
            return [
                MethodInfo(name: "onRevokeMsg:(id)arg1", type: "-"),
                MethodInfo(name: "AddMsg:(id)arg1 MsgWrap:(id)arg2", type: "-"),
                MethodInfo(name: "GetMsg:(id)arg1 LocalID:(unsigned int)arg2", type: "-")
            ]
        } else if className == "UIView" {
            return [
                MethodInfo(name: "setFrame:(CGRect)frame", type: "-"),
                MethodInfo(name: "setBackgroundColor:(UIColor *)color", type: "-"),
                MethodInfo(name: "layoutSubviews", type: "-")
            ]
        } else {
            return [
                MethodInfo(name: "init", type: "-"),
                MethodInfo(name: "description", type: "-"),
                MethodInfo(name: "sharedInstance", type: "+"),
                MethodInfo(name: "doSomethingWithArg:(id)arg1", type: "-")
            ]
        }
    }
    
    var body: some View {
        List(methods) { method in
            NavigationLink(destination: PatchEditorView(targetApp: targetApp, className: className, methodName: method.name)) {
                HStack {
                    Text(method.type)
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(method.type == "+" ? .purple : .blue)
                        .frame(width: 20)
                    
                    Text(method.name)
                        .font(.system(.body, design: .monospaced))
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle(className)
        .searchable(text: $searchText, prompt: "搜索方法")
    }
}
