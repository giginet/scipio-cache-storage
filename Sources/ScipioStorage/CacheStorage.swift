import Foundation

public protocol CacheStorage {
    func existsValidCache(for cacheKey: some CacheKey) async throws -> Bool
    func fetchArtifacts(for cacheKey: some CacheKey, to destinationDir: URL) async throws
    func cacheFramework(_ frameworkPath: URL, for cacheKey: some CacheKey) async throws
    var parallelNumber: Int? { get }
}

public protocol CacheKey: Hashable, Codable, Equatable {
    var targetName: String { get }
}
