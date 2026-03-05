import SwiftUI

enum MenuScreen {
    case list, addTask, today
}

struct MenuBarView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var screen: MenuScreen = .list

    var body: some View {
        Group {
            switch screen {
            case .list:
                TaskListScreen(screen: $screen)
            case .addTask:
                AddTaskScreen(screen: $screen)
            case .today:
                TodayScreen(screen: $screen)
            }
        }
        .environmentObject(taskManager)
        .frame(minWidth: 260)
        .padding(8)
    }
}

// MARK: - Task List

private struct TaskListScreen: View {
    @EnvironmentObject var taskManager: TaskManager
    @Binding var screen: MenuScreen

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

            Divider().padding(.vertical, 4)

            Button(action: { screen = .addTask }) {
                Label("Add Task", systemImage: "plus")
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)

            Button(action: { screen = .today }) {
                Label("Today", systemImage: "calendar")
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)

            Divider().padding(.vertical, 4)

            Button(action: { NSApplication.shared.terminate(nil) }) {
                Label("Quit", systemImage: "power")
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
        }
    }
}

// MARK: - Add Task (inline)

private struct AddTaskScreen: View {
    @EnvironmentObject var taskManager: TaskManager
    @Binding var screen: MenuScreen
    @State private var taskName = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("New Task")
                .font(.headline)
                .padding(.horizontal, 8)

            TextField("Task name", text: $taskName)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .onSubmit { create() }
                .padding(.horizontal, 8)

            HStack {
                Button("Cancel") { screen = .list }
                    .keyboardShortcut(.cancelAction)
                Spacer()
                Button("Create") { create() }
                    .keyboardShortcut(.defaultAction)
                    .disabled(taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 8)
        }
        .padding(.vertical, 8)
        .onAppear {
            // 少し遅らせてフォーカスを当てないと MenuBarExtra のウィンドウが
            // まだアクティブになっていないケースがある
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }

    private func create() {
        taskManager.addTask(name: taskName)
        screen = .list
    }
}

// MARK: - Today Summary (inline)

private struct TodayScreen: View {
    @EnvironmentObject var taskManager: TaskManager
    @Binding var screen: MenuScreen

    private var todayTasks: [Task] {
        let start = Calendar.current.startOfDay(for: Date())
        return taskManager.tasks.filter { $0.createdAt >= start || $0.totalSeconds > 0 }
    }

    private var totalSeconds: Int {
        todayTasks.reduce(0) { $0 + $1.totalSeconds }
            + (taskManager.currentTaskId != nil ? taskManager.elapsedSeconds : 0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Summary")
                    .font(.headline)
                Spacer()
                Button("Back") { screen = .list }
            }
            .padding(.horizontal, 8)

            Divider()

            if todayTasks.isEmpty {
                Text("No tasks yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 8)
            } else {
                ForEach(todayTasks) { task in
                    let seconds = task.totalSeconds
                        + (taskManager.currentTaskId == task.id ? taskManager.elapsedSeconds : 0)
                    HStack {
                        Text(task.name).lineLimit(1)
                        Spacer()
                        Text(taskManager.formatTime(seconds))
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 8)
                }

                Divider()

                HStack {
                    Text("Total").fontWeight(.bold)
                    Spacer()
                    Text(taskManager.formatTime(totalSeconds))
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(.vertical, 8)
    }
}
