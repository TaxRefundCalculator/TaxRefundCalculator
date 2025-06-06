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
    
    // 유저디플트에 저장된 기준화폐 불러오기
    private let baseCurrencyRelay = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: "BaseCurrency") ?? "KRW")

    var baseCurrency: Observable<String> {
        return baseCurrencyRelay.asObservable()
    }
    
    private let savedCardsRelay = BehaviorRelay<[SavedCard]>(value: [])

    var savedCards: Observable<[SavedCard]> {
        return savedCardsRelay.asObservable()
    }

    private let selectedDateRangeRelay = BehaviorRelay<(Date?, Date?)>(value: (nil, nil))
    
    var selectedDateRange: Observable<(Date?, Date?)> {
        return selectedDateRangeRelay.asObservable()
    }
    
    var filteredCards: Observable<[SavedCard]> {
        return Observable.combineLatest(savedCardsRelay, selectedDateRangeRelay)
            .map { cards, range in
                guard let start = range.0, let end = range.1 else { return cards }
                return cards.filter { card in
                    guard let cardDate = DateUtils.toDate(card.date) else { return false }
                    return cardDate >= start && cardDate <= end
                }
            }
    }
    
    func setDateRange(start: Date?, end: Date?) {
        selectedDateRangeRelay.accept((start, end))
    }
    
    func saveMockData() {
        let mock = [
            SavedCard(flag: "🇺🇸", country: "미국", date: "2025.05.20", purchaseAmount: "100 USD", refundAmount: "8.33 USD", convertedPurchaseAmount: 1400, convertedRefundAmount: 300, convertedCurrency: "KRW"),
            SavedCard(flag: "🇩🇪", country: "독일", date: "2025.05.21", purchaseAmount: "400 EUR" , refundAmount: "66.67 EUR", convertedPurchaseAmount: 1400, convertedRefundAmount: 1000, convertedCurrency: "KRW"),
            SavedCard(flag: "🇺🇸", country: "미국", date: "2025.05.27", purchaseAmount: "200 USD", refundAmount: "16.66 USD", convertedPurchaseAmount: 2800, convertedRefundAmount: 500, convertedCurrency: "KRW"),
            SavedCard(flag: "🇩🇪", country: "독일", date: "2025.05.28", purchaseAmount: "200 EUR", refundAmount: "33.33 EUR", convertedPurchaseAmount: 2800, convertedRefundAmount: 666, convertedCurrency: "KRW")
        ]
        savedCardsRelay.accept(mock)
    }
}
