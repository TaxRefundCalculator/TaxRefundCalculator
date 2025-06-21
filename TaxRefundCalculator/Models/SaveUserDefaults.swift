//
//  UserDefaults.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 5/17/25.
//

import Foundation

protocol SaveUserDefaultsProtocol { // 캡슐화
    // 정보 저장용
    func saveLanguage(_ language: String)
    func saveBaseCurrency(_ currency: String)
    func saveTravelCountry(_ currency: String)
    func saveIsDoneFirstStep(_ done: Bool)
}

class SaveUserDefaults: SaveUserDefaultsProtocol {
    
    private let userDefaults = UserDefaults.standard
    private let listKey = "SavedCardKeys" // [String] (키들의 순서 저장)
    
    // MARK: 정보 저장용
    // 저장
    func saveLanguage(_ language: String) { // 언어
        userDefaults.set(language, forKey: "selectedLanguage")
    }
    func saveBaseCurrency(_ currency: String) { // 기준 통화
        userDefaults.set(currency, forKey: "baseCurrency")
    }
    func saveTravelCountry(_ country: String) { // 여행국가
        userDefaults.set(country, forKey: "travelCountry")
    }
    func saveIsDoneFirstStep(_ done: Bool) { // 초기설정
        userDefaults.set(done, forKey: "doneFirstStep")
    }
    
    // 불러오기
    func getLanguage() -> String? { // 언어
        return userDefaults.string(forKey: "selectedLanguage")
    }
    func getBaseCurrency() -> String? { // 기준통화
        return userDefaults.string(forKey: "baseCurrency")
    }
    func getTravelCountry() -> String? { // 여행국가
        return userDefaults.string(forKey: "travelCountry")
    }
    func getIsDoneFirstStep() -> Bool { // 초기설정
        return userDefaults.bool(forKey: "doneFirstStep")
    }
    
    
    // MARK: 다크모드
    private var darkModeKey: String { "darkModeEnabled" }
    // 저장
    func saveDarkModeEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: darkModeKey)
    }
    
    // 불러오기
    func getDarkModeEnabled() -> Bool {
        userDefaults.bool(forKey: darkModeKey)
    }
    
    
    // MARK: 기록 초기화
    func deleteAllrecords() {
        userDefaults.removeObject(forKey: "SavedCardList")
    }
    
}

// MARK: 설정탭 기록카드 관련
extension SaveUserDefaults {
    /// 모든 SavedCard 배열을 1개 Key("SavedCardList")로 통째로 저장
    func overwriteAllCards(_ cards: [SavedCard]) {
        if let encoded = try? JSONEncoder().encode(cards) {
            userDefaults.set(encoded, forKey: "SavedCardList")
        }
    }
    
    /// 모든 SavedCard를 불러오기
    func loadAllCards() -> [SavedCard] {
        if let data = userDefaults.data(forKey: "SavedCardList"),
           let decoded = try? JSONDecoder().decode([SavedCard].self, from: data) {
            return decoded
        }
        return []
    }
    
    /// 기록 추가
    func addCard(_ card: SavedCard) {
        var cards = loadAllCards()
        cards.append(card)
        overwriteAllCards(cards)
    }
}
