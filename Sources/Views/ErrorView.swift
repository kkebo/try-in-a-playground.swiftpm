import SwiftUI

struct ErrorView<E: Error> {
    let error: E
}

extension ErrorView: View {
    var body: some View {
        VStack(spacing: 16) {
            Label("Error", systemImage: "xmark.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.title)
            Text(self.error.localizedDescription)
        }
        .padding()
    }
}
