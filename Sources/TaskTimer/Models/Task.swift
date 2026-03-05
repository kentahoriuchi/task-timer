import Foundation

struct Task: Identifiable, Codable {
    var id: UUID
    var name: String
    var totalSeconds: Int
    var createdAt: Date

    init(id: UUID = UUID(), name: String, totalSeconds: Int = 0, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.totalSeconds = totalSeconds
        self.createdAt = createdAt
    }
}
