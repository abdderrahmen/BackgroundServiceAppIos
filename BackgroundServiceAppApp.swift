import SwiftUI
import BackgroundTasks

@main
struct BackgroundServiceAppApp: App {
    init() {
        // Enregistre les tâches d'arrière-plan lors de l'initialisation de l'application
        BackgroundTaskHandler.shared.registerBackgroundTasks()
    }

    var body: some Scene {
        WindowGroup {
            ContentView() // Appelle ContentView où on gère onAppear
        }
    }
}

