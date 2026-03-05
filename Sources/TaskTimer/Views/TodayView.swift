import SwiftUI

struct TodayView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Binding var isPresented: Bool

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
                Button("Done") { isPresented = false }
            }

            Divider()

            if todayTasks.isEmpty {
                Text("No tasks yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(todayTasks) { task in
                    let seconds = task.totalSeconds + (taskManager.currentTaskId == task.id ? taskManager.elapsedSeconds : 0)
                    HStack {
                        Text(task.name)
                            .lineLimit(1)
                        Spacer()
                        Text(taskManager.formatTime(seconds))
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                }

                Divider()

                HStack {
                    Text("Total")
                        .fontWeight(.bold)
                    Spacer()
                    Text(taskManager.formatTime(totalSeconds))
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.bold)
                }
            }
        }
        .padding()
        .frame(width: 300)
    }
}
