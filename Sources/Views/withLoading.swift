import SwiftUI

@MainActor func withLoading<Result: Sendable>(
    isLoading: Binding<Bool>,
    _ body: () async throws -> Result
) async rethrows -> Result {
    isLoading.wrappedValue = true
    defer { isLoading.wrappedValue = false }
    return try await body()
}
