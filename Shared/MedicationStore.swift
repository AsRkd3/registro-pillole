import Foundation
import Combine

@MainActor
final class MedicationStore: ObservableObject {
    @Published private(set) var events: [MedicationEvent] = []

    private let storageKey = "registro-pillole.events.v1"

    init() {
        load()
        SyncCoordinator.shared.configure(store: self)
    }

    func add(_ medication: Medication) {
        let event = MedicationEvent(medication: medication)
        events.insert(event, at: 0)
        save()
        SyncCoordinator.shared.send(.upsert(event))
    }

    func delete(_ event: MedicationEvent) {
        events.removeAll { $0.id == event.id }
        save()
        SyncCoordinator.shared.send(.delete(event.id))
    }

    func apply(_ message: SyncMessage) {
        switch message.action {
        case .upsert:
            guard let event = message.event else { return }
            if let index = events.firstIndex(where: { $0.id == event.id }) {
                events[index] = event
            } else {
                events.append(event)
            }
            events.sort { $0.timestamp > $1.timestamp }
            save()
        case .delete:
            guard let id = message.eventID else { return }
            events.removeAll { $0.id == id }
            save()
        }
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let savedEvents = try? JSONDecoder().decode([MedicationEvent].self, from: data)
        else {
            events = []
            return
        }
        events = savedEvents.sorted { $0.timestamp > $1.timestamp }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(events) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
