import SwiftUI

struct WatchContentView: View {
    @EnvironmentObject private var store: MedicationStore

    private var groupedEvents: [(day: Date, events: [MedicationEvent])] {
        let grouped = Dictionary(grouping: store.events) {
            Calendar.current.startOfDay(for: $0.timestamp)
        }
        return grouped.keys.sorted(by: >).map { day in
            let events = (grouped[day] ?? []).sorted { $0.timestamp > $1.timestamp }
            return (day, events)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    medicationButton(.eutirox, color: .blue)
                    medicationButton(.blopress, color: .green)
                } header: {
                    Text("Registra")
                }

                Section {
                    if store.events.isEmpty {
                        Text("Nessuna registrazione")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(groupedEvents, id: \.day) { group in
                            Section(group.day.formatted(date: .abbreviated, time: .omitted)) {
                                ForEach(group.events) { event in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(event.medication.rawValue)
                                                .font(.headline)
                                            Text(event.timestamp.formatted(date: .omitted, time: .shortened))
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            store.delete(event)
                                        } label: {
                                            Label("Elimina", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    }
                } header: {
                    Text("Storico")
                }
            }
            .navigationTitle("Registro Pillole")
        }
    }

    private func medicationButton(_ medication: Medication, color: Color) -> some View {
        Button {
            store.add(medication)
        } label: {
            HStack {
                Image(systemName: "pills.fill")
                Text(medication.rawValue)
                    .font(.headline)
                Spacer(minLength: 0)
            }
            .padding(.vertical, 5)
        }
        .listItemTint(color)
    }
}
