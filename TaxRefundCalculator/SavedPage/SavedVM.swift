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
    
    private let selectedCurrencyRelay = BehaviorRelay<String?>(value: nil)
    var selectedCurrency: Observable<String?> { selectedCurrencyRelay.asObservable() }
    
    var filteredCards: Observable<[SavedCard]> {
        return Observable.combineLatest(savedCardsRelay, selectedDateRangeRelay, selectedCurrencyRelay)
            .map { cards, range, selectedCurrency in
                var result = cards
                // 날짜 필터
                if let start = range.0, let end = range.1 {
                    result = result.filter { card in
                        guard let cardDate = DateUtils.toDate(card.date) else { return false }
                        return cardDate >= start && cardDate <= end
                    }
                }
                // 통화 필터
                if let selectedCurrency = selectedCurrency {
                    result = result.filter { $0.baseCurrencyCode == selectedCurrency }
                }
                // if selectedCurrency is nil, do not filter by currency (show all)
                return result
            }
    }
    
    // 기준통화 필터 관련
    var availableCurrencies: [String] {
        let codes = savedCardsRelay.value.map { $0.baseCurrencyCode }
        let uniqueCodes = Array(Set(codes))
        // 저장된 순서를 보장하려면 아래처럼
        var ordered: [String] = []
        for card in savedCardsRelay.value {
            if !ordered.contains(card.baseCurrencyCode) {
                ordered.append(card.baseCurrencyCode)
            }
        }
        return ordered
    }
    
    func setDateRange(start: Date?, end: Date?) {
        selectedDateRangeRelay.accept((start, end))
    }
    
    func loadSavedCards() {
        let allCards = SaveUserDefaults().loadAllCards()
        savedCardsRelay.accept(allCards)
    }
    
    func setSelectedCurrency(_ code: String?) {
        selectedCurrencyRelay.accept(code)
    }
    
    // 삭제
    func deleteCard(withId id: String) {
        var current = savedCardsRelay.value
        if let idx = current.firstIndex(where: { $0.id == id }) {
            current.remove(at: idx)
            savedCardsRelay.accept(current)
            SaveUserDefaults().overwriteAllCards(current)
        }
    }
}
