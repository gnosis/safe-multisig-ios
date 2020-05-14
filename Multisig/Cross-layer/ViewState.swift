//
//  ViewState.swift
//  Multisig
//
//  Created by Moaaz on 5/13/20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

class ViewState: ObservableObject {

    static let shared = ViewState()
    
    @Published
    var state: ViewStateMode = .balanaces
    
    private init() {
        
    }
}

enum ViewStateMode: Hashable {
    case balanaces
    case transactions
    case settings
}