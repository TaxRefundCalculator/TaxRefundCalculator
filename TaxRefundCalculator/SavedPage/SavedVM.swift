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
    
    func loadSavedCards() {
        let allCards = SaveUserDefaults().loadAllCards()
        savedCardsRelay.accept(allCards)
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
