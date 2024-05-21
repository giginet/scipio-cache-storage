import Foundation
import CryptoKit

private let jsonEncoder = {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    return encoder
}()

public protocol CacheStorage: Sendable {
    func existsValidCache(for cacheKey: some CacheKey) async throws -> Bool
    func fetchArtifacts(for cacheKey: some CacheKey, to destinationDir: URL) async throws
    func cacheFramework(_ frameworkPath: URL, for cacheKey: some CacheKey) async throws
    var parallelNumber: Int? { get }
}

public protocol CacheKey: Hashable, Codable, Equatable, Sendable {
    var targetName: String { get }
}

extension CacheKey {
    public var frameworkName: String {
        "\(targetName.packageNamed()).xcframework"
    }
}

extension CacheKey {
    public func calculateChecksum() throws -> String {
        let data = try jsonEncoder.encode(self)
        return SHA256.hash(data: data)
            .map { String(format: "%02hhx", $0) }
            .joined()
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
