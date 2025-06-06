//
//  SettingVM.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import Foundation
import SnapKit
import Then

class SettingVM {
    
    let saveUserDefaults = SaveUserDefaults()
    
    // MARK: userDefaults 저장 메서드
    func saveSelectedLanguage(_ language: String) {
        saveUserDefaults.saveLanguage(language)
    }
    func saveBaseCurrency(_ baseCurrency: String) {
        saveUserDefaults.saveBaseCurrency(baseCurrency)
    }
    func saveTravelCurrency(_ travelCurrency: String) {
        saveUserDefaults.saveTravelCurrency(travelCurrency)
    }
    
    // MARK: userDefaults 조회 메서드
    func getSelectedLanguage() -> String? {
        return saveUserDefaults.getLanguage()
    }
    func getBaseCurrency() -> String? {
        return saveUserDefaults.getBaseCurrency()
    }
    func getTravelCurrency() -> String? {
        return saveUserDefaults.getTravelCurrency()
    }
    
    
    
}
