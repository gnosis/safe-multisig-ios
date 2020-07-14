//
//  CollectibleCellView.swift
//  Multisig
//
//  Created by Moaaz on 7/9/20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import SwiftUI

struct CollectibleCellView: View {
    let viewModel: CollectibleViewModel

    private let imageDimention: CGFloat = 144
    var body: some View {
        HStack (alignment: .top) {
            TokenImage(width: imageDimention, height: imageDimention, url: viewModel.imageURL, name: "ico-collectible-placeholder")

            VStack (alignment: .leading, spacing: 10) {
                BodyText(viewModel.name, textColor: nameTextColor).font(Font.gnoBody.weight(.semibold))
                BodyText(viewModel.description)
            }.padding(.vertical)

            Spacer()
        }
        .cornerRadius(10, antialiased: true)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.white)
                .cardShadowTooltip()
        )
    }

    private var nameTextColor: Color {
        viewModel.hasName ? .gnoDarkBlue : .gnoLightGrey
    }
}