//
//  CalculateVM.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then

class CalculateVM {
    
    let saveUserDefaults = SaveUserDefaults()
    
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
    func getRefundPolicyByCurrency() -> (flag: String, policy: VATRefundPolicy)? {
        guard let travelCurrency = getTravelCurrency() else { return nil }
        
        print("유저디폴트에 저장된 국가: \(travelCurrency)")
        
        let flag = travelCurrency.first.map { String($0) } ?? ""
        print("추출된 국기: \(flag)")
        print("flagToPolicyMap keys: \(RefundCondition.flagToPolicyMap.keys)")
        return RefundCondition.flagToPolicyMap[flag].map { (flag, $0) }
    }
    
    // MARK: 유저디폴트에 있는 화폐들, 부가세 띄우기
    // 부가세
    func getVatRate() -> String? {
        return getRefundPolicyByCurrency().map { "\($0.policy.vatRate)%" }
    }
    
    // 여행국가 통화
    func getTravelCurrency3() -> (full: String, code: String)? {
        guard let currency = getTravelCurrency() else { return nil }
        return (currency, String(currency.suffix(3))) // 뒤에서 3글자만 추출
    }
    
    // 기준통화
    func getBaseCurrency3() -> String? {
        return getBaseCurrency().map { String($0.suffix(3)) }
    }
    
}
