import SwiftUI

struct LogView: View {
    // Mock Logs
    struct LogEntry: Identifiable {
        let id = UUID()
        let timestamp: Date
        let level: String
        let message: String
        
        var color: Color {
            switch level {
            case "INFO": return .blue
            case "WARN": return .orange
            case "ERROR": return .red
            default: return .primary
            }
        }
    }
    
    let logs = [
        LogEntry(timestamp: Date(), level: "INFO", message: "App started"),
        LogEntry(timestamp: Date().addingTimeInterval(-10), level: "WARN", message: "Method execution slow"),
        LogEntry(timestamp: Date().addingTimeInterval(-20), level: "ERROR", message: "Hook failed for -[UIView setFrame:]")
    ]
    
    var body: some View {
        NavigationView {
            List(logs) { log in
                VStack(alignment: .leading) {
                    HStack {
                        Text("[\(log.level)]")
                            .font(.caption)
                            .bold()
                            .foregroundColor(log.color)
                        Text(log.timestamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Text(log.message)
                        .font(.body)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("运行日志")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("导出") {
                        // Action
                    }
                }
            }
        }
    }
}
