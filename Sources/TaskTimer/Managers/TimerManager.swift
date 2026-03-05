import Foundation

class TimerManager {
    private var timer: Timer?
    private var startTime: Date?
    private(set) var currentTaskId: UUID?

    var onTick: ((Int) -> Void)?

    func start(taskId: UUID) {
        stop()
        currentTaskId = taskId
        startTime = Date()
        let t = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self, let start = self.startTime else { return }
            let elapsed = Int(Date().timeIntervalSince(start))
            self.onTick?(elapsed)
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    /// Stops the timer and returns (taskId, elapsedSeconds), or nil if nothing was running.
    @discardableResult
    func stop() -> (id: UUID, elapsed: Int)? {
        guard let taskId = currentTaskId, let start = startTime else { return nil }
        timer?.invalidate()
        timer = nil
        let elapsed = Int(Date().timeIntervalSince(start))
        currentTaskId = nil
        startTime = nil
        return (taskId, elapsed)
    }
}
