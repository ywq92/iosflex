import SwiftUI

struct ClassBrowserView: View {
    @State private var searchText = ""
    
    // Mock Data
    struct ClassInfo: Identifiable {
        let id = UUID()
        let name: String
        let framework: String
    }
    
    let classes = [
        ClassInfo(name: "UIView", framework: "UIKit"),
        ClassInfo(name: "UIButton", framework: "UIKit"),
        ClassInfo(name: "NSString", framework: "Foundation"),
        ClassInfo(name: "CustomManager", framework: "App")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Dictionary(grouping: classes, by: { $0.framework }).sorted(by: { $0.key < $1.key }), id: \.key) { framework, classes in
                    Section(header: Text(framework)) {
                        ForEach(classes) { cls in
                            NavigationLink(destination: MethodListView(className: cls.name)) {
                                Text(cls.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("类浏览器")
            .searchable(text: $searchText)
        }
    }
}

struct MethodListView: View {
    let className: String
    
    var body: some View {
        List {
            Text("Methods for \(className)")
            // Implementation for method list would go here
        }
        .navigationTitle(className)
    }
}
