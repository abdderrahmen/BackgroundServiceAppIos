import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Background Service App")
                .font(.title)
                .padding()
            Text("L'application fonctionne en arrière-plan.")
                .font(.body)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

