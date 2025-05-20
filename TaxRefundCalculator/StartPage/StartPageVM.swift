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
    
    
    //MARK: 온오프라인 토글버튼 로직
    func getNetworkStatus(isOnline: Bool) -> (text: String, color: UIColor) {
        if isOnline {
            return ("온라인 모드", .mainTeal)
        } else {
            return ("오프라인 모드", .downRed)
        }
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
