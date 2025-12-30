import SwiftUI

struct PatchEditorView: View {
    var targetApp: InstalledApp? // Optional, passed from AppList
    var className: String?
    var methodName: String?
    
    @State private var patchName = "New Patch"
    @State private var code = ""
    
    init(targetApp: InstalledApp? = nil, className: String? = nil, methodName: String? = nil) {
        self.targetApp = targetApp
        self.className = className
        self.methodName = methodName
        
        let initialName: String
        if let method = methodName {
             initialName = "Hook \(method)"
        } else if let app = targetApp {
             initialName = "Patch for \(app.name)"
        } else {
             initialName = "New Patch"
        }
        _patchName = State(initialValue: initialName)
        
        // Generate Template Code
        let cls = className ?? "TargetClass"
        let sel = methodName ?? "targetMethod:"
        let template = """
        // HOOK: [\(cls) \(sel)]
        
        #import <Foundation/Foundation.h>
        #import <UIKit/UIKit.h>
        
        %hook \(cls)
        
        \(sel) {
            NSLog(@"[FlexCN] Executing \(sel)");
            
            // Call original implementation
            %orig;
            
            // Add your custom logic here
        }
        
        %end
        """
        _code = State(initialValue: template)
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
                
                if let cls = className {
                    HStack {
                        Text("目标类")
                        Spacer()
                        Text(cls).font(.system(.body, design: .monospaced))
                    }
                }
                
                if let method = methodName {
                    HStack {
                        Text("目标方法")
                        Spacer()
                        Text(method).font(.system(.body, design: .monospaced))
                    }
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
