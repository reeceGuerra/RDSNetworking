//
//  RDSNEnvironmentProvider.swift
//  RDSNetworking
//
//  Created by Carlos Lopez on 27/10/25.
//

import Foundation

public protocol RDSNEnvironmentProvider: Sendable {
    /// Resolves the base URL for a given logical host.
    ///
    /// The returned URL MUST include at least the scheme and host (e.g., "https://api.example.com")
    /// and MAY include a base path suffix when applicable (e.g., "https://api.example.com/v1").
    ///
    /// - Parameter host: The logical host group requested by an endpoint.
    /// - Returns: A fully qualified base URL that will be combined with the endpoint's relative path.
    func baseURL(for host: RDSNApiHost) -> URL
}
