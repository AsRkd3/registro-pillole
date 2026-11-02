import SwiftUI

@main
struct RegistroPilloleApp: App {
    @StateObject private var store = MedicationStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
