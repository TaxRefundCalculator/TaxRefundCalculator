//
//  SettingVM.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import Foundation
import SnapKit
import Then
import Combine

class SettingVM {
    
    // MARK: 싱글톤 패턴
    static let shared = SettingVM()
    private init() {} // 외부에서 생성 방지
    
    // MARK: Combine - 기존화폐, 여행화폐 변경시 최신화를 위함
    @Published var baseCurrency: String = ""
    @Published var travelCurrency: String = ""
    
    let saveUserDefaults = SaveUserDefaults()
    
    // MARK: userDefaults 저장 메서드
    func saveSelectedLanguage(_ language: String) {
        saveUserDefaults.saveLanguage(language)
    }
    func saveBaseCurrency(_ baseCurrency: String) {
        saveUserDefaults.saveBaseCurrency(baseCurrency) // 유저디폴트에 저장
        self.baseCurrency = baseCurrency // @Published 갱신
    }
    func saveTravelCurrency(_ travelCurrency: String) {
        saveUserDefaults.saveTravelCurrency(travelCurrency) // 유저디폴트에 저장
        self.travelCurrency = travelCurrency // @Published 갱신
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
