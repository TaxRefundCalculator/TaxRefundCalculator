//
//  SavedModalVM.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 6/26/25.
//

import UIKit
import RxCocoa
import RxSwift

final class SavedModalVM {
    
    /// Input
    let savedCard: SavedCard
    
    /// Output
    let country: Driver<String>
    let date: Driver<String>
    let purchaseAmount: Driver<String>
    let refundAmount: Driver<String>
    let convertedPurchase: Driver<String>
    let convertedRefund: Driver<String>
    let exchangeRate: Driver<String>
    let conditionText: Driver<String>
    
    init(savedCard: SavedCard, policy: VATRefundPolicy) {
        self.savedCard = savedCard
        
        // 각 출력값을 Driver로 변환하여 노출
        self.country = Driver.just(savedCard.country)
        self.date = Driver.just(savedCard.date)
        self.purchaseAmount = Driver.just("\(savedCard.price) \(savedCard.currencyCode)")
        self.refundAmount = Driver.just("\(savedCard.refundPrice) \(savedCard.currencyCode)")
        self.convertedPurchase = Driver.just("\(savedCard.convertedPrice) \(savedCard.baseCurrencyCode)")
        self.convertedRefund = Driver.just("\(savedCard.convertedRefundPrice) \(savedCard.baseCurrencyCode)")
        self.exchangeRate = Driver.just(savedCard.exchangeRate)
        self.conditionText = Driver.just("""
        💰 \(NSLocalizedString("VAT Rate:", comment: ""))  \(policy.vatRate)%\n
        💵 \(NSLocalizedString("Minimum Purchase Amount:", comment: ""))  \(Int(policy.minimumAmount)) \(policy.currencyCode)\n
        🔁 \(NSLocalizedString("Refund Method:", comment: ""))  \(NSLocalizedString(policy.refundMethod, comment: ""))\n
        📍 \(NSLocalizedString("Refund Location:", comment: ""))  \(NSLocalizedString(policy.refundPlace, comment: ""))\n
        📌 \(NSLocalizedString("Notes:", comment: ""))  \(NSLocalizedString(policy.notes, comment: ""))
        """)
    }
}
