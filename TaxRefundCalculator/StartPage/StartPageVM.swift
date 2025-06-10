//
//  StartPageVM.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then

class StartPageVM {
    
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

    
    // MARK: 국기 인식 및 환급기준 매칭
    func getRefundPolicy(for text: String) -> (flag: String, policy: VATRefundPolicy)? {
        let flagEmojis = RefundCondition.flagToPolicyMap.keys
        for flag in flagEmojis {
            if text.contains(flag), let policy = RefundCondition.flagToPolicyMap[flag] {
                return (flag, policy)
            }
        }
        
        return nil
    }
    
    // MARK: 환급 조건 텍스트 불러오기
    func refundConditionText(for country: String) -> String {
        if let (_, policy) = getRefundPolicy(for: country) {
            print("📌 환급 정책: \(policy)")
            return "최소 \(Int(policy.minimumAmount)) \(policy.currencyCode) 구매 시 \(policy.vatRate)% 환급"
        } else {
            return "환급 정책을 찾을 수 없습니다."
        }
    }
}
