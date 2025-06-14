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
    
    
    // MARK: 계산 기록 저장용
    // 저장
    func saveCards(_ cards: [SavedCard]) {
        let newKey = makeUniqueKey()
        
        // 1. 저장
        if let encoded = try? JSONEncoder().encode(cards) {
            userDefaults.set(encoded, forKey: newKey)
        }
        
        // 2. 키 리스트에 추가
        var allKeys = loadAllKeys()
        allKeys.append(newKey)
        userDefaults.set(allKeys, forKey: listKey)
    }

    // 불러오기
    func loadGroupedCards() -> [(key: String, cards: [SavedCard])] {
        let keys = loadAllKeys()
        var result: [(String, [SavedCard])] = []
        
        for key in keys {
            if let data = userDefaults.data(forKey: key),
               let decoded = try? JSONDecoder().decode([SavedCard].self, from: data) {
                result.append((key, decoded))
            }
        }
        return result
    }

    // MARK: 키와 날짜로 중복방지
    // 고유 키 생성
    private func makeUniqueKey() -> String {
        let date = currentDateString()
        var index = 1
        var key = "\(date)_\(index)"
        let existingKeys = loadAllKeys()
        
        while existingKeys.contains(key) {
            index += 1
            key = "\(date)_\(index)"
        }
        return key
    }
    
    // 구분용 날짜
    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    private func loadAllKeys() -> [String] {
        return userDefaults.stringArray(forKey: listKey) ?? []
    }
   
}
