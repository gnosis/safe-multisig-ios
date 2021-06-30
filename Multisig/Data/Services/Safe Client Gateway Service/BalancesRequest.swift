//
//  BalancesRequest.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 02.11.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import Foundation

struct BalancesRequest: JSONRequest {
    private let safeAddress: String
    private let networkId: Int
    private let fiat: String
    #warning("Check if we need these two")
    private var isTrusted: Bool?
    private var isExcludeSpam: Bool?

    var httpMethod: String { "GET" }

    var urlPath: String {
        "/\(networkId)/v1/safes/\(safeAddress)/balances/\(fiat)"
    }

    var query: String? {
        let output = [
            isTrusted.map { "trusted=\($0)"},
            isExcludeSpam.map { "exclude_spam=\($0)" }
        ].compactMap { $0 }.joined(separator: "&")
        return output.isEmpty ? nil : output
    }

    typealias ResponseType = SafeBalanceSummary
}

extension BalancesRequest {
    init(_ safeAddress: Address, networkId: Int) {
        self.init(safeAddress: safeAddress.checksummed,
                  networkId: networkId,
                  fiat: AppSettings.selectedFiatCode)
    }
}

struct SafeBalanceSummary: Decodable {
    var fiatTotal: String
    var items: [SCGBalance]
}

struct SCGBalance: Decodable {
    var tokenInfo: TokenInfo
    var balance: UInt256String
    var fiatBalance: String
    var fiatConversion: String
}

extension SafeClientGatewayService {
    func asyncBalances(safeAddress: Address,
                       networkId: Int,
                       completion: @escaping (Result<SafeBalanceSummary, Error>) -> Void) -> URLSessionTask? {
        asyncExecute(request: BalancesRequest(safeAddress, networkId: networkId), completion: completion)
    }
}
