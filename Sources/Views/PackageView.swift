import SwiftUI

struct PackageView {
    let generator: PlaygroundGenerator
}

extension PackageView: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Text("Dependency:")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("\(self.generator.packageURL)")
                        .truncationMode(.middle)
                    Spacer()
                    Text("from: \(self.generator.latestVersion)")
                        .layoutPriority(1)
                }
                .lineLimit(1)
            }
            Button("Create App") {
                self.generator.generate()
            }
            .buttonStyle(.borderedProminent)
            .hoverEffect()
        }
        .padding()
    }
}
