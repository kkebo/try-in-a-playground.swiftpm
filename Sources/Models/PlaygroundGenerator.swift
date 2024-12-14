import Foundation
import Version

enum PlaygroundGeneratorError: Error {
    case unexpectedScheme(String)
    case unknownAction(String)
    case invalidURL(URL)
    case missingDependenciesQuery
    case notYetReleased
}

extension PlaygroundGeneratorError: CustomStringConvertible {
    var description: String {
        switch self {
        case .unexpectedScheme(let scheme): "The scheme \"\(scheme)\" is unexpected."
        case .unknownAction(let action): "The action \"\(action)\" is not supported."
        case .invalidURL(let url): "\(url) is invalid."
        case .missingDependenciesQuery: "The query \"dependencies\" is missing."
        case .notYetReleased: "The package is not yet released."
        }
    }
}

struct PlaygroundGenerator {
    let packageName: String
    let packageURL: URL
    let latestVersion: String

    init(url: URL) async throws {
        guard let scheme = url.scheme, let host = url.host() else {
            throw PlaygroundGeneratorError.invalidURL(url)
        }
        guard scheme == "spi-playgrounds" else {
            throw PlaygroundGeneratorError.unexpectedScheme(scheme)
        }
        guard host == "open" else { throw PlaygroundGeneratorError.unknownAction(host) }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw PlaygroundGeneratorError.invalidURL(url)
        }
        guard let name = components.queryItems?.first(where: { $0.name == "dependencies" })?.value
        else { throw PlaygroundGeneratorError.missingDependenciesQuery }
        let tagsURL =
            githubAPIBaseURL
            .appending(path: "repos")
            .appending(path: name)
            .appending(path: "git/matching-refs/tags")
        let (data, _) = try await URLSession.shared.data(from: tagsURL)
        let tag = try JSONDecoder().decode(GitReferences.self, from: data).lazy
            .map(\.ref)
            .map { $0.trimmingPrefix("refs/tags/") }
            .compactMap { Version(tolerant: $0) }
            .filter { $0.prereleaseIdentifiers.isEmpty }
            .max()
        guard let tag else { throw PlaygroundGeneratorError.notYetReleased }
        self.packageName = name
        self.packageURL = githubBaseURL.appending(component: name)
        self.latestVersion = tag.description
    }

    func generate() {
        // TODO: Implement here
    }
}
