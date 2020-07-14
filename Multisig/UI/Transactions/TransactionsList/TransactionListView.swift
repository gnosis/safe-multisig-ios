//
//  TransactionListView.swift
//  Multisig
//
//  Created by Moaaz on 5/29/20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

struct TransactionListView: Loadable {
    @ObservedObject
    var model: TransactionsViewModel

    init(safe: Safe) {
        model = TransactionsViewModel(safe: safe)
    }

    var body: some View {
        ZStack {
            if model.transactionsList.isEmpty {
                EmptyListPlaceholder(label: "Transactions will appear here", image: "ico-no-transactions")
            } else {
                transactionsList
            }
        }
        .onAppear {
            self.trackEvent(.transactions)
        }
    }

    var transactionsList: some View {
        List {
            ForEach(model.transactionsList.sections) { section in
                Section(header: SectionHeader(section.name)) {
                    ForEach(section.transactions) { transaction in
                        NavigationLink(destination: TransactionDetailsView(transaction: transaction)) {
                            TransactionCell(transaction: transaction)
                        }.onAppear {
                            if self.model.isLast(transaction: transaction) && self.model.canLoadNext {
                                self.model.loadNextPage()
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                }
            }

            if model.isLoadingNextPage {
                ActivityIndicator(isAnimating: .constant(true), style: .medium).frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
