//
//  TransactionViewModel.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 15.06.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import Foundation

class TransactionViewModel: Identifiable {

    let id: UUID
    var nonce: String?
    var status: TransactionStatus
    var date: Date?
    var formattedDate: String
    var confirmationCount: Int?
    var threshold: Int?
    var confirmations: [TransactionConfirmationViewModel]?
    var remainingConfirmationsRequired: Int
    var hasConfirmations: Bool {
        confirmations.map { !$0.isEmpty } ?? false
    }

    static let dateFormatter: DateFormatter = {
        let d = DateFormatter()
        d.locale = .autoupdatingCurrent
        d.dateStyle = .medium
        d.timeStyle = .medium
        return d
    }()

    init() {
        id = UUID()
        status = .success
        formattedDate = ""
        confirmations = []
        remainingConfirmationsRequired = 0
    }

    init(_ tx: Transaction, _ safe: SafeStatusRequest.Response) {
        id = UUID()
        date = tx.executionDate ?? tx.submissionDate ?? tx.modified
        formattedDate = date.map { Self.dateFormatter.string(from: $0) } ?? ""
        confirmations = tx.confirmations.map { $0.map(TransactionConfirmationViewModel.init(confirmation:)) }
        // computing confirmation counters
        do {
            let confirmationCount = confirmations?.count ?? 0
            let requiredCount = Int(clamping: tx.confirmationsRequired?.value ?? safe.threshold.value)
            let remainingCount = max(requiredCount - confirmationCount, 0)

            self.confirmationCount = confirmationCount
            self.threshold = requiredCount
            remainingConfirmationsRequired = remainingCount
        }
        status = tx.status(safeNonce: safe.nonce.value,
                           safeThreshold: safe.threshold.value)
        nonce = tx.nonce.map { String($0.value) }
    }

}