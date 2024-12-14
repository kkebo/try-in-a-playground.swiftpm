import SwiftUI

@MainActor
struct ContentView {
    @State private var generator: Result<PlaygroundGenerator, any Error>?
    @State private var isLoading = false

    private func openURL(_ url: URL) {
        Task {
            do {
                self.generator = try await withLoading(isLoading: self.$isLoading) {
                    try await .success(.init(url: url))
                }
            } catch {
                self.generator = .failure(error)
            }
        }
    }
}

extension ContentView: View {
    var body: some View {
        Group {
            if self.isLoading {
                LoadingView()
            } else {
                switch self.generator {
                case nil: WelcomeView()
                case .success(let generator): PackageView(generator: generator)
                case .failure(let error): ErrorView(error: error)
                }
            }
        }
        .onOpenURL { url in
            self.openURL(url)
        }
    }
}
