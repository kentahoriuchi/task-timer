import SwiftUI

@main
struct TaskTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var taskManager = TaskManager()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .environmentObject(taskManager)
        } label: {
            MenuBarLabel(taskManager: taskManager)
        }
        .menuBarExtraStyle(.window)
    }
}

private struct MenuBarLabel: View {
    @ObservedObject var taskManager: TaskManager

    private var currentTaskName: String? {
        guard let id = taskManager.currentTaskId else { return nil }
        return taskManager.tasks.first(where: { $0.id == id })?.name
    }

    var body: some View {
        HStack(spacing: 4) {
            Text("⌚")
            if let name = currentTaskName {
                // タスク名は最大80ptで打ち切り、幅を固定
                Text(name)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 80, alignment: .leading)
                Text(taskManager.formatTime(taskManager.elapsedSeconds))
                    .monospacedDigit()
            } else {
                Text("No Task")
            }
        }
        // 外枠を固定幅にしてラベル全体が動かないようにする
        .frame(width: 180, alignment: .leading)
    }
}
