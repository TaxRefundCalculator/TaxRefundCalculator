//
//  UserDefaults.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 5/17/25.
//

import UIKit

protocol SaveUserDefaultsProtocol {
    func saveLanguage(_ language: String)
    func saveBaseCurrency(_ currency: String)
    func saveTravelCurrency(_ currency: String)
}

class SaveUserDefaults: SaveUserDefaultsProtocol {
    
    // 저장
    func saveLanguage(_ language: String) {
        UserDefaults.standard.set(language, forKey: "selectedLanguage")
    }
    func saveBaseCurrency(_ currency: String) {
        UserDefaults.standard.set(currency, forKey: "baseCurrency")
    }
    func saveTravelCurrency(_ currency: String) {
        UserDefaults.standard.set(currency, forKey: "travelCurrency")
    }
    
    // 불러오기
    func getLanguage() -> String? {
        return UserDefaults.standard.string(forKey: "selectedLanguage")
    }
    func getBaseCurrency() -> String? {
        return UserDefaults.standard.string(forKey: "baseCurrency")
    }
    func getTravelCurrency() -> String? {
        return UserDefaults.standard.string(forKey: "travelCurrency")
    }
}
