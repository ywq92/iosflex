import SwiftUI

struct PatchEditorView: View {
    var targetApp: InstalledApp? // Optional, passed from AppList
    
    @State private var patchName = "New Patch"
    @State private var code = """
    // Custom OC Code
    id newImplementation(id self, SEL _cmd, int x) {
        NSLog(@"Param x: %d", x);
        return originalMethod(self, _cmd, x + 1);
    }
    """
    
    init(targetApp: InstalledApp? = nil) {
        self.targetApp = targetApp
        _patchName = State(initialValue: targetApp != nil ? "Patch for \(targetApp!.name)" : "New Patch")
    }
    
    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                TextField("补丁名称", text: $patchName)
                if let app = targetApp {
                    Text("目标应用: \(app.name)")
                    Text("Bundle ID: \(app.bundleId)")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text("目标应用: 未选择")
                }
            }
            
            Section(header: Text("HOOK 配置")) {
                NavigationLink("选择方法") {
                    Text("Method Selector (Coming Soon)")
                }
                
                Picker("HOOK 类型", selection: .constant(0)) {
                    Text("替换方法").tag(0)
                    Text("前缀注入").tag(1)
                    Text("后缀注入").tag(2)
                }
            }
            
            Section(header: Text("代码编辑")) {
                TextEditor(text: $code)
                    .font(.system(.body, design: .monospaced))
                    .frame(height: 200)
            }
            
            Section {
                Button("测试执行") {
                    // Action
                }
                Button("保存补丁") {
                    // Action
                }
            }
        }
        .navigationTitle("补丁编辑器")
    }
}
