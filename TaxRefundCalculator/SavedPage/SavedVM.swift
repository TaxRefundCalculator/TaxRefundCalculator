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
    
    // MARK: - Outputs
    
    /// 현재 선택된 기준화폐 (UserDefaults에서 불러옴)
    private let baseCurrencyRelay = BehaviorRelay<String>(value: UserDefaults.standard.string(forKey: "BaseCurrency") ?? "KRW")
    var baseCurrency: Observable<String> {
        return baseCurrencyRelay.asObservable()
    }
    
    /// 저장된 기록 카드 배열
    private let savedCardsRelay = BehaviorRelay<[SavedCard]>(value: [])
    var savedCards: Observable<[SavedCard]> {
        return savedCardsRelay.asObservable()
    }
    
    /// 날짜 범위 선택 상태 (시작~끝)
    private let selectedDateRangeRelay = BehaviorRelay<(Date?, Date?)>(value: (nil, nil))
    var selectedDateRange: Observable<(Date?, Date?)> {
        return selectedDateRangeRelay.asObservable()
    }
    
    /// 기준통화 선택 상태
    private let selectedCurrencyRelay = BehaviorRelay<String?>(value: nil)
    var selectedCurrency: Observable<String?> { selectedCurrencyRelay.asObservable() }
    
    /// 현재 필터링된 카드 배열 (날짜/통화 기준)
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
                return result
            }
    }
    
    /// 기록 내 사용된 모든 기준통화 목록 (중복 없이, 저장 순서 보장)
    var availableCurrencies: [String] {
        let codes = savedCardsRelay.value.map { $0.baseCurrencyCode }
        var ordered: [String] = []
        for card in savedCardsRelay.value {
            if !ordered.contains(card.baseCurrencyCode) {
                ordered.append(card.baseCurrencyCode)
            }
        }
        return ordered
    }
    
    // MARK: - Inputs (상태 갱신 및 비즈니스 로직)
    
    /// 날짜 범위 선택값 갱신
    func setDateRange(start: Date?, end: Date?) {
        selectedDateRangeRelay.accept((start, end))
    }
    
    /// 기록 데이터 불러오기 (UserDefaults에서 전체)
    func loadSavedCards() {
        let allCards = SaveUserDefaults().loadAllCards()
        savedCardsRelay.accept(allCards)
    }
    
    /// 기준통화 선택값 갱신
    func setSelectedCurrency(_ code: String?) {
        selectedCurrencyRelay.accept(code)
    }
    
    /// 특정 카드 삭제 (삭제 후 저장)
    func deleteCard(withId id: String) {
        var current = savedCardsRelay.value
        if let idx = current.firstIndex(where: { $0.id == id }) {
            current.remove(at: idx)
            savedCardsRelay.accept(current)
            SaveUserDefaults().overwriteAllCards(current)
        }
    }
}
