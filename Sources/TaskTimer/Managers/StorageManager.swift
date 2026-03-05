import Foundation

class StorageManager {
    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("TaskTimer", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("tasks.json")
    }

    func load() -> [Task] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        return (try? JSONDecoder().decode([Task].self, from: data)) ?? []
    }

    func save(_ tasks: [Task]) {
        guard let data = try? JSONEncoder().encode(tasks) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
