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
    
    let vatRateTitle: Driver<String>
    let vatRateValue: Driver<String>
    let minimumAmountTitle: Driver<String>
    let minimumAmountValue: Driver<String>
    let refundMethodTitle: Driver<String>
    let refundMethodValue: Driver<String>
    let refundPlaceTitle: Driver<String>
    let refundPlaceValue: Driver<String>
    let notesTitle: Driver<String>
    let notesValue: Driver<String>
    
    init(savedCard: SavedCard, policy: VATRefundPolicy) {
        self.savedCard = savedCard
        
        // 각 출력값을 Driver로 변환하여 노출
        self.country = Driver.just(savedCard.country)
        self.date = Driver.just(savedCard.date)
        self.purchaseAmount = Driver.just("\(savedCard.price.roundedString()) \(savedCard.currencyCode)")
        self.refundAmount = Driver.just("\(savedCard.refundPrice.roundedString()) \(savedCard.currencyCode)")
        self.convertedPurchase = Driver.just("\(savedCard.convertedPrice.roundedString()) \(savedCard.baseCurrencyCode)")
        self.convertedRefund = Driver.just("\(savedCard.convertedRefundPrice.roundedString()) \(savedCard.baseCurrencyCode)")
        self.exchangeRate = Driver.just(savedCard.exchangeRate)
        self.vatRateTitle = Driver.just("💰 " + NSLocalizedString("VAT Rate", comment: ""))
        self.vatRateValue = Driver.just("\(policy.vatRate)%")
        self.minimumAmountTitle = Driver.just("💵 " + NSLocalizedString("Minimum Purchase Amount", comment: ""))
        self.minimumAmountValue = Driver.just("\(Int(policy.minimumAmount)) \(policy.currencyCode)")
        self.refundMethodTitle = Driver.just("🔁 " + NSLocalizedString("Refund Method", comment: ""))
        self.refundMethodValue = Driver.just(NSLocalizedString(policy.refundMethod, comment: ""))
        self.refundPlaceTitle = Driver.just("📍 " + NSLocalizedString("Refund Location", comment: ""))
        self.refundPlaceValue = Driver.just(NSLocalizedString(policy.refundPlace, comment: ""))
        self.notesTitle = Driver.just("📌 " + NSLocalizedString("Notes", comment: ""))
        self.notesValue = Driver.just(NSLocalizedString(policy.notes, comment: ""))
    }
}
