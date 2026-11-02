import SwiftUI

@main
struct RegistroPilloleWatchApp: App {
    @StateObject private var store = MedicationStore()

    var body: some Scene {
        WindowGroup {
            WatchContentView()
                .environmentObject(store)
        }
    }
}
