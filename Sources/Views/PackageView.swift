import SwiftUI

struct PackageView {
    let generator: PlaygroundGenerator
    @State private var packageURL: URL?

    private var isGenerated: Binding<Bool> {
        .init(
            get: { self.packageURL != nil },
            set: {
                if !$0 {
                    self.packageURL = nil
                }
            }
        )
    }
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
                self.packageURL = try? self.generator.generate()
            }
            .buttonStyle(.borderedProminent)
            .hoverEffect()
        }
        .padding()
        .fileMover(isPresented: self.isGenerated, file: self.packageURL) { _ in }
    }
}
