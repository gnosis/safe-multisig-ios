//
//  SafeLoadedViewController.swift
//  Multisig
//
//  Created by Moaaz on 1/19/21.
//  Copyright © 2021 Gnosis Ltd. All rights reserved.
//

import UIKit

class SafeLoadedViewController: UIViewController {
    @IBOutlet weak var safeInfoView: SafeInfoViewV2!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var importOwnerKeyButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!

    private var safe: Safe!
    private let descriptionText = " is read-only. Would you like to add owner key for this Safe to confirm transactions?"
    var completion: () -> Void = { }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        navigationItem.title = "Load Gnosis Safe"
        do {
            safe = try Safe.getSelected()!
            descriptionLabel.text = (safe.name ?? "Safe") + descriptionText
            titleLabel.setStyle(.headline)
            descriptionLabel.setStyle(.primary)
            importOwnerKeyButton.setText("Add owner key", .filled)
            skipButton.setText("Skip", .primary)
            safeInfoView.set(safe.name)
            safeInfoView.setAddress(safe.addressValue)
        } catch {
            fatalError()
        }
    }

    @IBAction func importOwnerButtonTouched(_ sender: Any) {
        Tracker.trackEvent(.userOnboardingOwnerAdd)
        let vc = ViewControllerFactory.addOwnerViewController { [unowned self] in
            self.dismiss(animated: true) {
                self.completion()
            }
        }
        present(vc, animated: true)
    }

    @IBAction func skipButtonTouched(_ sender: Any) {
        Tracker.trackEvent(.userOnboardingOwnerSkip)
        completion()
    }
}
