//
//  EnableDisableModuleTransactionDetailsHeaderView.swift
//  Multisig
//
//  Created by Moaaz on 6/17/20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

struct EnableDisableModuleHeaderView: View {
    let state: State
    var address: Address

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            BoldText(title)
            AddressCell(address: address.checksummed, style: .shortAddress)
        }
    }

    var title: String {
        switch state {
        case .enable:
            return "Enable module:"
        case .disable:
            return "Disable module:"
        }
    }
    
    enum State {
        case enable
        case disable
    }
}

struct EnableDisableModuleTransactionDetailsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        EnableDisableModuleHeaderView(state: .enable, address: "0xb35Ac2DF4f0D0231C5dF37C1f21e65569600bdd2")
    }
}
