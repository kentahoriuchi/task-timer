import Foundation
import Combine

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    @Published private(set) var currentTaskId: UUID?
    @Published private(set) var elapsedSeconds: Int = 0

    private let storage = StorageManager()
    private let timerManager = TimerManager()

    init() {
        tasks = storage.load()
        timerManager.onTick = { [weak self] elapsed in
            self?.elapsedSeconds = elapsed
        }
    }

    func startTask(_ task: Task) {
        if currentTaskId == task.id {
            stopCurrentTask()
            return
        }
        stopCurrentTask()
        currentTaskId = task.id
        elapsedSeconds = 0
        timerManager.start(taskId: task.id)
    }

    func stopCurrentTask() {
        guard let result = timerManager.stop() else { return }
        if let idx = tasks.firstIndex(where: { $0.id == result.id }) {
            tasks[idx].totalSeconds += result.elapsed
        }
        currentTaskId = nil
        elapsedSeconds = 0
        storage.save(tasks)
    }

    func addTask(name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        tasks.append(Task(name: trimmed))
        storage.save(tasks)
    }

    func deleteTask(_ task: Task) {
        if currentTaskId == task.id {
            timerManager.stop()
            currentTaskId = nil
            elapsedSeconds = 0
        }
        tasks.removeAll { $0.id == task.id }
        storage.save(tasks)
    }

    func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
