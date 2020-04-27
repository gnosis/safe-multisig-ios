//
//  SafeAddressFormModel.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 24.04.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import Foundation
import Combine

class SafeAddressFormModel: ObservableObject {

    enum FormError: LocalizedError {
        case safeExists

        var errorDescription: String? {
            "There is already a Safe with this address in the app. Please use another address."
        }
    }

    @Published
    var text: String = ""

    @Published
    var displayText: String = ""

    @Published
    var isAddress: Bool = false

    @Published
    var isValid: Bool?

    @Published
    var isValidating: Bool = false

    @Published
    var errorMessage: String = ""

    private var subscribers = Set<AnyCancellable>()

    func validate(address: String) {
        subscribers.forEach { $0.cancel() }

        $text
            .filter { !$0.isEmpty }
            .removeDuplicates()
            .map { v -> String in
                self.reset()
                return v.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .tryMap { text -> String in
                let address = try Address(hex: text, eip55: false)
                return address.hex(eip55: true)
            }
            .map { v -> String in
                self.isAddress = true
                self.displayText = address

                self.isValidating = true
                return v
            }
            .receive(on: DispatchQueue.global())
            .tryMap { address -> String in
                try Safe.download(at: address)
                return address
            }
            .receive(on: RunLoop.main)
            .tryMap { address -> String in
                let exists = try Safe.alreadyExists(address)
                if exists  { throw FormError.safeExists }
                return address
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.setError(error.localizedDescription)
                }
            }, receiveValue: { address in
                self.isValidating = false
                self.isValid = true
            })
            .store(in: &subscribers)
    }

    func reset() {
        isValidating = false
        isAddress = false
        isValid = nil
        errorMessage = ""
    }

    func setError(_ message: String) {
        self.isValidating = false
        self.isValid = false

        self.errorMessage = message
        self.displayText = self.text
    }
}
