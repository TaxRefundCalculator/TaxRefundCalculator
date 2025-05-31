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
    
    
    // MARK: 국기 인식 및 환급기준 매칭
    func getRefundPolicy(for text: String) -> VATRefundPolicy? {
        // 추출 가능한 이모지 범위로 가정: 국기 이모지 유니코드는 대부분 두 글자
        let flagEmojis = RefundCondition.flagToPolicyMap.keys
        
        for flag in flagEmojis {
            if text.contains(flag) {
                return RefundCondition.flagToPolicyMap[flag]
            }
        }
        
        return nil
    }
    
}
