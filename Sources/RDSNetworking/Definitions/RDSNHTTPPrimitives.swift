//
//  RDSNHTTPPrimitives.swift
//  RDSNetworking
//
//  Created by Carlos Lopez on 27/10/25.
//

import Foundation

// MARK: - HTTP Method

public enum RDSNHTTPMethod: String, Sendable {
    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS, TRACE, CONNECT
}

// MARK: - HTTP Headers

public struct RDSNHTTPHeaders: Sendable {
    private var storage: [String: String] = [:]

    public init() {}

    /// Sets or replaces a header value.
    /// - Parameters:
    ///   - name: Header field name (e.g., "Authorization").
    ///   - value: Header value.
    public mutating func set(_ name: String, _ value: String) {
        storage[name] = value
    }

    /// Returns the value for a given header name.
    /// - Parameter name: Header field name.
    /// - Returns: Stored value if present.
    public func value(for name: String) -> String? {
        storage[name]
    }

    /// Merges headers, overriding duplicates with entries from `other`.
    /// - Parameter other: Another header collection.
    public mutating func merge(_ other: RDSNHTTPHeaders) {
        for (k, v) in other.storage { storage[k] = v }
    }

    /// Exposes headers as a native dictionary. Use with care.
    public var dictionary: [String: String] { storage }

    /// True when the collection has no items.
    public var isEmpty: Bool { storage.isEmpty }
}

// MARK: - Multipart Part

public struct RDSNMultipartPart: Sendable {
    public let name: String
    public let filename: String?
    public let mimeType: String?
    public let data: Data

    /// Creates a multipart part.
    /// - Parameters:
    ///   - name: Field name.
    ///   - filename: Optional filename (include an extension when applicable).
    ///   - mimeType: Optional MIME type (e.g., "application/pdf").
    ///   - data: Raw bytes of the content.
    public init(name: String, filename: String? = nil, mimeType: String? = nil, data: Data) {
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
        self.data = data
    }
}

// MARK: - HTTP Body

public enum RDSNBody: Sendable {
    /// No body.
    case none

    /// A JSON payload as raw bytes.
    /// - Note: The HTTP client may set `Content-Type: application/json` if not present.
    case json(Data)

    /// A `application/x-www-form-urlencoded` payload from query items.
    /// - Important: Items must be percent-encoded using `URLQueryItem` semantics.
    case formURLEncoded([URLQueryItem])

    /// An arbitrary payload with an explicit `Content-Type`.
    /// - Parameters:
    ///   - data: Raw payload.
    ///   - contentType: MIME type to set on the request (e.g., "text/plain; charset=utf-8").
    case raw(Data, contentType: String)

    /// A `multipart/form-data` payload described by a list of parts.
    /// - Note: The HTTP client will generate a boundary and set the proper content type.
    case multipart([RDSNMultipartPart])
}
