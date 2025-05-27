//
//  SavedVM.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/28/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SavedVM {
    private let savedCardsRelay = BehaviorRelay<[SavedCard]>(value: [])

    var savedCards: Observable<[SavedCard]> {
        return savedCardsRelay.asObservable()
    }

    func saveMockData() {
        let mock = [
            SavedCard(flag: "🇺🇸", country: "미국", date: "2025.05.26", purchaseAmount: "100 USD", refundAmount: "8.33 USD"),
            SavedCard(flag: "🇩🇪", country: "독일", date: "2025.05.20", purchaseAmount: "400 EUR", refundAmount: "66.67 EUR"),
            SavedCard(flag: "🇺🇸", country: "미국", date: "2025.05.27", purchaseAmount: "200 USD", refundAmount: "16.66 USD"),
            SavedCard(flag: "🇩🇪", country: "독일", date: "2025.05.21", purchaseAmount: "200 EUR", refundAmount: "33.33 EUR")
        ]
        savedCardsRelay.accept(mock)
    }
}
