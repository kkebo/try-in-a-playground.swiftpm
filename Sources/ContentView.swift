import SwiftUI

@MainActor
struct ContentView {
    @State private var generator: PlaygroundGenerator?
    @State private var isLoading = false
    @State private var error: (any Error)?

    private func openURL(_ url: URL) {
        Task {
            self.isLoading = true
            defer { self.isLoading = false }
            do {
                self.generator = try await .init(url: url)
            } catch {
                self.error = error
            }
        }
    }
}

extension ContentView: View {
    var body: some View {
        Group {
            if let generator {
                VStack(spacing: 16) {
                    VStack {
                        Text("Dependency:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text("\(generator.packageURL)")
                                .truncationMode(.middle)
                            Spacer()
                            Text("from: \(generator.latestVersion)")
                                .layoutPriority(1)
                        }
                        .lineLimit(1)
                    }
                    Button("Create App") {
                        generator.generate()
                    }
                    .buttonStyle(.borderedProminent)
                    .hoverEffect()
                }
                .padding()
            } else if self.isLoading {
                HStack {
                    ProgressView()
                    Text("Loading...")
                }
                .padding()
            } else if let error {
                VStack(spacing: 16) {
                    Label("Error", systemImage: "xmark.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.title)
                    Text(error.localizedDescription)
                }
                .padding()
            } else {
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
        .onOpenURL { url in
            self.openURL(url)
        }
    }
}
