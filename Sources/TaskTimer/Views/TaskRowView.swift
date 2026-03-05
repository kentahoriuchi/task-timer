import SwiftUI

struct TaskRowView: View {
    @EnvironmentObject var taskManager: TaskManager
    let task: Task

    private var isRunning: Bool {
        taskManager.currentTaskId == task.id
    }

    private var displayTime: String {
        let total = task.totalSeconds + (isRunning ? taskManager.elapsedSeconds : 0)
        return taskManager.formatTime(total)
    }

    var body: some View {
        HStack {
            Image(systemName: isRunning ? "circle.fill" : "circle")
                .foregroundColor(isRunning ? .green : .secondary)
                .frame(width: 16)

            Text(task.name)
                .fontWeight(isRunning ? .bold : .regular)
                .lineLimit(1)

            Spacer()

            Text(displayTime)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(isRunning ? .green : .secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isRunning ? Color.green.opacity(0.1) : Color.clear)
        .cornerRadius(6)
        .contentShape(Rectangle())
        .onTapGesture {
            taskManager.startTask(task)
        }
        .contextMenu {
            Button("Delete", role: .destructive) {
                taskManager.deleteTask(task)
            }
        }
    }
}
