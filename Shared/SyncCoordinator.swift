import Foundation
import WatchConnectivity

final class SyncCoordinator: NSObject, WCSessionDelegate {
    static let shared = SyncCoordinator()

    private weak var store: MedicationStore?

    private override init() {
        super.init()
    }

    func configure(store: MedicationStore) {
        self.store = store
        guard WCSession.isSupported() else { return }

        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    func send(_ message: SyncMessage) {
        guard WCSession.isSupported(),
              WCSession.default.activationState == .activated,
              let data = try? JSONEncoder().encode(message)
        else { return }

        WCSession.default.transferUserInfo(["payload": data])
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        guard activationState == .activated else { return }

        Task { @MainActor [weak self] in
            guard let self, let store = self.store else { return }
            for event in store.events {
                self.send(.upsert(event))
            }
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        guard let data = userInfo["payload"] as? Data,
              let message = try? JSONDecoder().decode(SyncMessage.self, from: data)
        else { return }

        Task { @MainActor [weak self] in
            self?.store?.apply(message)
        }
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
}
