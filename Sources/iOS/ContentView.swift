import SwiftUI

struct ContentView: View {
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
                Section("Registra assunzione") {
                    medicationButton(.eutirox, color: .blue)
                    medicationButton(.blopress, color: .green)
                }

                Section("Storico") {
                    if store.events.isEmpty {
                        ContentUnavailableView(
                            "Nessuna registrazione",
                            systemImage: "pills",
                            description: Text("Le registrazioni effettuate su Apple Watch compariranno qui.")
                        )
                    } else {
                        ForEach(groupedEvents, id: \.day) { group in
                            Section {
                                ForEach(group.events) { event in
                                    EventRow(event: event)
                                        .swipeActions {
                                            Button(role: .destructive) {
                                                store.delete(event)
                                            } label: {
                                                Label("Elimina", systemImage: "trash")
                                            }
                                        }
                                }
                            } header: {
                                Text(group.day.formatted(date: .complete, time: .omitted))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Registro Pillole")
        }
    }

    private func medicationButton(_ medication: Medication, color: Color) -> some View {
        Button {
            store.add(medication)
        } label: {
            Label(medication.rawValue, systemImage: "pills.fill")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)
        }
        .tint(color)
    }
}

private struct EventRow: View {
    let event: MedicationEvent

    var body: some View {
        HStack {
            Label(event.medication.rawValue, systemImage: "pills.fill")
            Spacer()
            Text(event.timestamp.formatted(date: .omitted, time: .shortened))
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
    }
}
