//
//  UserDefaults.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 5/17/25.
//

import Foundation

protocol SaveUserDefaultsProtocol {
    func saveLanguage(_ language: String)
    func saveBaseCurrency(_ currency: String)
    func saveTravelCountry(_ currency: String)
    func saveIsDoneFirstStep(_ done: Bool)
}

class SaveUserDefaults: SaveUserDefaultsProtocol {
    
    // MARK: 저장
    func saveLanguage(_ language: String) { // 언어
        UserDefaults.standard.set(language, forKey: "selectedLanguage")
    }
    func saveBaseCurrency(_ currency: String) { // 기준 통화
        UserDefaults.standard.set(currency, forKey: "baseCurrency")
    }
    func saveTravelCountry(_ currency: String) { // 여행국가
        UserDefaults.standard.set(currency, forKey: "travelCurrency")
    }
    func saveIsDoneFirstStep(_ done: Bool) { // 초기설정
        UserDefaults.standard.set(done, forKey: "doneFirstStep")
    }
    
    // MARK: 불러오기
    func getLanguage() -> String? { // 언어
        return UserDefaults.standard.string(forKey: "selectedLanguage")
    }
    func getBaseCurrency() -> String? { // 기준통화
        return UserDefaults.standard.string(forKey: "baseCurrency")
    }
    func getTravelCountry() -> String? { // 여행국가
        return UserDefaults.standard.string(forKey: "travelCurrency")
    }
    func getIsDoneFirstStep() -> Bool { // 초기설정
        return UserDefaults.standard.bool(forKey: "doneFirstStep")
    }
}
