//
//  Colors.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 14.04.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

extension Color {

    static let gnoBlack15 = Color("black15")
    static let gnoCardShadow = Color("cardShadow")
    static let gnoCardShadowPassword = Color("cardShadowPassword")
    static let gnoCardShadowTooltip = Color("cardShadowTooltip")
    static let gnoDarkBlue = Color("darkBlue")
    static let gnoDarkBlue50 = Color("darkBlue50")
    static let gnoDarkGrey = Color("darkGrey")
    static let gnoHold = Color("hold")
    static let gnoHold20 = Color("hold20")
    static let gnoHold50 = Color("hold50")
    static let gnoHoldTwo = Color("holdTwo")
    static let gnoLightGreen = Color("lightGreen")
    static let gnoLightGrey = Color("lightGrey")
    static let gnoMediumGrey = Color("mediumGrey")
    static let gnoSnowwhite = Color("snowwhite")
    static let gnoSystemBlack = Color("systemBlack")
    static let gnoSystemSelection = Color("systemSelection")
    static let gnoSystemWhite = Color("systemWhite")
    static let gnoTomato = Color("tomato")
    static let gnoWhite = Color("white")
    static let gnoWhitesmoke = Color("whitesmoke")
    static let gnoWhitesmokeTwo = Color("whitesmokeTwo")

}

extension View {
    func cardShadowTooltip() -> some View {
        shadow(color: .gnoCardShadowTooltip, radius: 10, x: 1, y: 2)
    }
}
