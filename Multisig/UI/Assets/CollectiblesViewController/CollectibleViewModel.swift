//
//  CollectiblesViewModel.swift
//  Multisig
//
//  Created by Moaaz on 7/8/20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import Foundation

struct CollectibleListSection: Identifiable {
    let id = UUID()
    var name: String
    var imageURL: URL?
    var collectibles: [CollectibleViewModel]

    var isEmpty: Bool {
        collectibles.isEmpty
    }
}

struct CollectibleViewModel: Identifiable {
    var id: UUID
    var name: String
    var description: String
    var address: String
    var tokenID: String?
    var imageURL: URL?
    var website: URL?
    var websiteName: String?

    var hasName: Bool {
        !["", "Unknown"].contains(name)
    }
}

extension CollectibleViewModel {
    init() {
        id = UUID()
        name = ""
        description = ""
        address = ""
        tokenID = ""
        websiteName = ""
        imageURL = nil
        website = nil
    }

    init(collectible: Collectible) {
        id = UUID()
        name = collectible.name ?? "Unknown"
        description = collectible.description ?? ""
        address = collectible.address?.address.checksummed ?? ""
        tokenID = collectible.id
        imageURL = URL(string: collectible.imageUri ?? "")
        website = nil
        websiteName = ""
    }
}

extension CollectibleListSection {
    static func create(_  collectibles: [Collectible]) -> [Self] {
        let groupedCollectibles = Dictionary(grouping: collectibles, by: { $0.address })
        return groupedCollectibles.map { (key, value) in
            let token = App.shared.tokenRegistry[key!.address]
            let name = token?.name ?? value.first(where: { $0.tokenName != nil })?.tokenName ?? "Unknown"
            let logoURL = token?.logo ?? value.first(where: { $0.logoUri != nil })?.logoUri.flatMap { URL(string: $0) }
            let collectibles = value.compactMap { CollectibleViewModel(collectible: $0) }.sorted { $0.name < $1.name }
            return Self.init(name: name , imageURL: logoURL, collectibles: collectibles)
        }.sorted { $0.name < $1.name }
    }
}

