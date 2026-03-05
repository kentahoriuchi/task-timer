import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var showAddTask = false
    @State private var showToday = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if taskManager.tasks.isEmpty {
                Text("No tasks yet")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            } else {
                ForEach(taskManager.tasks) { task in
                    TaskRowView(task: task)
                }
            }

            Divider()
                .padding(.vertical, 4)

            Button(action: { showAddTask = true }) {
                Label("Add Task", systemImage: "plus")
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)

            Button(action: { showToday = true }) {
                Label("Today", systemImage: "calendar")
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)

            Divider()
                .padding(.vertical, 4)

            Button(action: { NSApplication.shared.terminate(nil) }) {
                Label("Quit", systemImage: "power")
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
        }
        .padding(8)
        .frame(minWidth: 260)
        .sheet(isPresented: $showAddTask) {
            AddTaskView(isPresented: $showAddTask)
                .environmentObject(taskManager)
        }
        .sheet(isPresented: $showToday) {
            TodayView(isPresented: $showToday)
                .environmentObject(taskManager)
        }
    }
}
