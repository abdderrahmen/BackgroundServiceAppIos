import BackgroundTasks
import Foundation

struct BackgroundTaskHandler {
    static let shared = BackgroundTaskHandler()

    /// Enregistre la tâche d'arrière-plan
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.BackgroundServiceApp.sync", using: nil) { task in
            // Gérer la tâche ici
            self.handleSyncTask(task: task as! BGProcessingTask)
        }
    }

    /// Planifie une tâche de synchronisation
    func scheduleBackgroundSyncTask() {
        let request = BGProcessingTaskRequest(identifier: "com.example.BackgroundServiceApp.sync")
        request.requiresNetworkConnectivity = true // Nécessite une connexion réseau
        request.requiresExternalPower = false // N'exige pas d'être branché à une alimentation

        do {
            try BGTaskScheduler.shared.submit(request)
            print("Tâche de synchronisation planifiée.")
        } catch {
            print("Erreur lors de la planification de la tâche d'arrière-plan : \(error)")
        }
    }

    /// Gère la tâche de synchronisation
    private func handleSyncTask(task: BGProcessingTask) {
        scheduleBackgroundSyncTask() // Planifie la prochaine tâche

        let queue = DispatchQueue(label: "com.example.BackgroundServiceApp.sync", qos: .background)
        queue.async {
            // Exemple de logique de synchronisation (remplace par ton code réel)
            self.performSync { success in
                task.setTaskCompleted(success: success)
            }
        }

        // Configure un gestionnaire d'expiration si nécessaire
        task.expirationHandler = {
            print("La tâche a expiré.")
            task.setTaskCompleted(success: false)
        }
    }

    /// Exemple de logique de synchronisation
    private func performSync(completion: @escaping (Bool) -> Void) {
        // Simule une tâche longue (remplace par ton code réel)
        print("Synchronisation en cours...")
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            print("Synchronisation terminée.")
            completion(true)
        }
    }
}

