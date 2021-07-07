//
//  AdvancedSafeSettingsViewController.swift
//  Multisig
//
//  Created by Moaaz on 2/3/21.
//  Copyright © 2021 Gnosis Ltd. All rights reserved.
//

import UIKit

fileprivate protocol SectionItem {}

class AdvancedSafeSettingsViewController: UITableViewController {    
    private typealias SectionItems = (section: Section, items: [SectionItem])

    private var safe: Safe!
    private var sections = [SectionItems]()

    var namingPolicy = DefaultAddressNamingPolicy()

    enum Section {
        case fallbackHandler(String)
        case guardInfo(String)
        case nonce(String)
        case modules(String)

        enum FallbackHandler: SectionItem {
            case fallbackHandler(AddressInfo?)
            case fallbackHandlerHelpLink
        }

        enum GuardInfo: SectionItem {
            case guardInfo(AddressInfo)
            case guardInfoHelpLink
        }

        enum Nonce: SectionItem {
            case nonce(String)
        }

        enum Module: SectionItem {
            case module(AddressInfo)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            safe = try Safe.getSelected()!
            buildSections()
        } catch {
            fatalError()
        }

        navigationItem.title = "Advanced"
        tableView.registerCell(BasicCell.self)
        tableView.registerCell(DetailAccountCell.self)
        tableView.registerCell(HelpLinkTableViewCell.self)
        tableView.registerHeaderFooterView(BasicHeaderView.self)
        tableView.backgroundColor = .secondaryBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackEvent(.settingsSafeAdvanced)
    }

    private func buildSections() {
        sections = [
            (section: .fallbackHandler("FALLBACK HANDLER"),
             items: [Section.FallbackHandler.fallbackHandler(App.shared.gnosisSafe.fallbackHandlerInfo(safe.fallbackHandlerInfo)),
                     Section.FallbackHandler.fallbackHandlerHelpLink])]
        if let guardInfo = safe.guardInfo {
            sections.append((section: .guardInfo("GUARD"),
                             items: [Section.GuardInfo.guardInfo(guardInfo),
                                     Section.GuardInfo.guardInfoHelpLink]))
        }

        sections.append((section: .nonce("NONCE"),
             items: [Section.Nonce.nonce(safe.nonce?.description ?? "0")]))

        if let modules = safe.modulesInfo, !modules.isEmpty {
            sections.append((section: .modules("ADDRESSES OF ENABLED MODULES"),
                 items: modules.map { Section.Module.module($0) }))
        }
    }
}

extension AdvancedSafeSettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case Section.FallbackHandler.fallbackHandler(let info):
            if let info = info {
                return addressDetailsCell(address: info.address,
                                          title: namingPolicy.name(info: info),
                                          imageUri: info.logoUri,
                                          indexPath: indexPath)
            } else {
                return tableView.basicCell(
                    name: "Not set", indexPath: indexPath, withDisclosure: false, canSelect: false)
            }
        case Section.FallbackHandler.fallbackHandlerHelpLink:
            return helpLinkCell(text: "What is a fallback handler and how does it relate to the Gnosis Safe",
                                               url: App.configuration.help.fallbackHandlerURL,
                                               indexPath: indexPath)
        case Section.GuardInfo.guardInfo(let info):
            return addressDetailsCell(address: info.address,
                                      title: namingPolicy.name(info: info),
                                      imageUri: info.logoUri,
                                      indexPath: indexPath)
        case Section.GuardInfo.guardInfoHelpLink:
            return helpLinkCell(text: "What is a guard and how that is used",
                                    url: App.configuration.help.guardURL,
                                    indexPath: indexPath)
        case Section.Nonce.nonce(let nonce):
            return tableView.basicCell(name: nonce,
                                       indexPath: indexPath,
                                       withDisclosure: false,
                                       canSelect: false)
        case Section.Module.module(let info):
            return addressDetailsCell(address: info.address,
                                      title: namingPolicy.name(info: info),
                                      imageUri: info.logoUri,
                                      indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection _section: Int) -> UIView? {
        let section = sections[_section].section
        let view = tableView.dequeueHeaderFooterView(BasicHeaderView.self)
        switch section {
        case Section.fallbackHandler(let name):
            view.setName(name)
        case Section.guardInfo(let name):
            view.setName(name)
        case Section.nonce(let name):
            view.setName(name)
        case Section.modules(let name):
            view.setName(name)
        }

        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection _section: Int) -> CGFloat {
        return BasicHeaderView.headerHeight
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case Section.FallbackHandler.fallbackHandler(let info):
            if info == nil {
                return BasicCell.rowHeight
            }
        case Section.GuardInfo.guardInfo(_):
            return BasicCell.rowHeight
        case Section.Nonce.nonce:
            return BasicCell.rowHeight
        default:
            break
        }
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        BasicCell.rowHeight
    }

    private func addressDetailsCell(address: Address, title: String?, imageUri: URL?, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(DetailAccountCell.self, for: indexPath)
        cell.setAccount(address: address, label: title, imageUri: imageUri)
        return cell
    }

    private func helpLinkCell(text: String, url: URL, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(HelpLinkTableViewCell.self, for: indexPath) as HelpLinkTableViewCell
        cell.descriptionLabel.hyperLinkLabel(linkText: text)
        cell.url = url
        return cell
    }
}
