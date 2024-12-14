import SwiftUI

struct LoadingView {}

extension LoadingView: View {
    var body: some View {
        HStack {
            ProgressView()
            Text("Loading...")
        }
        .padding()
    }
}
