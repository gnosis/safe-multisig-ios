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
    private let networkId: String
    private let fiat: String

    var httpMethod: String { "GET" }

    var urlPath: String {
        "/v1/chains/\(networkId)/safes/\(safeAddress)/balances/\(fiat)"
    }

    typealias ResponseType = SafeBalanceSummary
}

extension BalancesRequest {
    init(_ safeAddress: Address, networkId: String) {
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

protocol BalancesAPI {
    func asyncBalances(safeAddress: Address,
                       networkId: String,
                       completion: @escaping (Result<SafeBalanceSummary, Error>) -> Void) -> URLSessionTask?
}

extension SafeClientGatewayService: BalancesAPI {
    func asyncBalances(safeAddress: Address,
                       networkId: String,
                       completion: @escaping (Result<SafeBalanceSummary, Error>) -> Void) -> URLSessionTask? {
        asyncExecute(request: BalancesRequest(safeAddress, networkId: networkId), completion: completion)
    }
}
