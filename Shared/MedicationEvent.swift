import Foundation

enum Medication: String, Codable, CaseIterable, Identifiable {
    case eutirox = "EUTIROX"
    case blopress = "BLOPRESS"

    var id: String { rawValue }
}

struct MedicationEvent: Codable, Identifiable, Equatable {
    let id: UUID
    let medication: Medication
    let timestamp: Date

    init(id: UUID = UUID(), medication: Medication, timestamp: Date = Date()) {
        self.id = id
        self.medication = medication
        self.timestamp = timestamp
    }
}

struct SyncMessage: Codable {
    enum Action: String, Codable {
        case upsert
        case delete
    }

    let action: Action
    let event: MedicationEvent?
    let eventID: UUID?

    static func upsert(_ event: MedicationEvent) -> SyncMessage {
        SyncMessage(action: .upsert, event: event, eventID: nil)
    }

    static func delete(_ id: UUID) -> SyncMessage {
        SyncMessage(action: .delete, event: nil, eventID: id)
    }
}
