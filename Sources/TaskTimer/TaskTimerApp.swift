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
            Text(taskManager.menuBarLabel)
        }
        .menuBarExtraStyle(.window)
    }
}
