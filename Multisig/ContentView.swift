//
//  ContentView.swift
//  Multisig
//
//  Created by Dmitry Bespalov. on 14.04.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            Text("Balances")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("tab-icon-balances")
                        Text("Balances")
                    }
                }
                .tag(0)
            Text("Transactions")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("tab-icon-transactions")
                        Text("Transactions")
                    }
                }
                .tag(1)
            Text("Settings")
            .font(.title)
            .tabItem {
                VStack {
                    Image("tab-icon-settings")
                    Text("Settings")
                }
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
