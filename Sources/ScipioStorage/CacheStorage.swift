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

extension CacheKey {
    public var frameworkName: String {
        "\(targetName.packageNamed()).xcframework"
    }
}

extension CacheStorage {
    public var parallelNumber: Int? {
        nil
    }
}

extension String {
    func packageNamed() -> String {
        // Xcode replaces any non-alphanumeric characters in the target with an underscore
        // https://developer.apple.com/documentation/swift/imported_c_and_objective-c_apis/importing_swift_into_objective-c
        return self
            .replacingOccurrences(of: "[^0-9a-zA-Z]", with: "_", options: .regularExpression)
            .replacingOccurrences(of: "^[0-9]", with: "_", options: .regularExpression)
    }
}
