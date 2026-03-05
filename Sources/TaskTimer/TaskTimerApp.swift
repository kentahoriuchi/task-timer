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

    var body: some View {
        HStack(spacing: 4) {
            Text("⌚")
            Text(taskManager.currentTaskId != nil
                 ? taskManager.formatTime(taskManager.elapsedSeconds)
                 : "--:--:--")
            .monospacedDigit()
        }
        // 固定幅でラベルサイズを変動させない
        .frame(width: 100, alignment: .leading)
    }
}
