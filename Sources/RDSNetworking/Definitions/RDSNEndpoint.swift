//
//  RDSNEndpoint.swift
//  RDSNetworking
//
//  Created by Carlos Lopez on 27/10/25.
//

import Foundation

// MARK: - Auth & Host Context

public enum RDSNAuthRequirement: Sendable, Equatable {
    case none
    case basic
    case bearer
    case jwt
}

public enum RDSNApiHost: Sendable, Equatable {
    case maxBff
    case innovationBff
    case maxGateway
    case webApi
}

// MARK: - Endpoint Contract

public protocol RDSNEndpoint: Sendable {
    var host: RDSNApiHost { get }
    var path: String { get }
    var method: RDSNHTTPMethod { get }
    var query: [URLQueryItem]? { get }
    var headers: RDSNHTTPHeaders { get }
    var body: RDSNBody { get }
    var auth: RDSNAuthRequirement { get }
    var expectsEventStream: Bool { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var timeout: TimeInterval { get }
}

// MARK: - Defaults

public extension RDSNEndpoint {
    var query: [URLQueryItem]? { nil }
    var headers: RDSNHTTPHeaders { .init() }
    var body: RDSNBody { .none }
    var auth: RDSNAuthRequirement { .none }
    var expectsEventStream: Bool { false }
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
    var timeout: TimeInterval { 60 }

    /// Returns a normalized path that **guarantees** a leading slash.
    /// Callers may use this helper when constructing URLs to avoid subtle mistakes.
    /// - Returns: A path string beginning with "/".
    func normalizedPath() -> String {
        path.hasPrefix("/") ? path : "/\(path)"
    }
}
