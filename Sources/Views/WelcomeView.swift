import SwiftUI

struct WelcomeView {}

extension WelcomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Try in a Playground").font(.title)
            Text("How to Use").font(.title2)
            Grid(alignment: .topLeading, verticalSpacing: 8) {
                GridRow {
                    Text("1.")
                    Text(.init("Find your interested package on the [Swift Package Index](\(spiURL))"))
                }
                GridRow {
                    Text("2.")
                    Text("Tap \"Try in a Playground\" from any package page")
                }
            }
        }
        .padding()
    }
}
