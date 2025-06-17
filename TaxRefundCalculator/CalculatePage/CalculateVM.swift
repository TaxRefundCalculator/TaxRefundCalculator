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
    func getTravelCountry() -> String? {
        return saveUserDefaults.getTravelCountry()
    }
    func getRefundPolicyByCurrency() -> (flag: String, policy: VATRefundPolicy)? {
        guard let travelCountry = getTravelCountry() else { return nil }
        
        print("유저디폴트에 저장된 국가: \(travelCountry)")
        
        let flag = travelCountry.first.map { String($0) } ?? ""
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
    func getTravelCountry3() -> (full: String, code: String)? {
        guard let currency = getTravelCountry() else { return nil }
        return (currency, String(currency.suffix(3))) // 뒤에서 3글자만 추출
    }
    
    // 기준통화
    func getBaseCurrency3() -> String? {
        return getBaseCurrency().map { String($0.suffix(3)) }
    }
    
    
    // MARK: 계산 기록 저장하기
    func saveCard(_ card: SavedCard) {
        saveUserDefaults.saveCards([card])
    }
    
    // 디버깅용
    func loadGroupedCards() -> [(String, [SavedCard])] {
        return saveUserDefaults.loadGroupedCards()
    }
    
    // MARK: 구매금액 입력 검증
    func isValidFloatingPoint(_ value: String) -> Bool {
        // 입력값이 빈 문자열이면(=삭제 상황) true 반환 → 삭제 허용
        if value.isEmpty { return true }
        
        // 0~9, '.'(dot) 이외의 문자가 포함되면 false 반환 → 입력 거부
        let allowed = CharacterSet(charactersIn: "0123456789.")
        if value.rangeOfCharacter(from: allowed.inverted) != nil { return false }
        
        // 소수점(.)이 2개 이상 들어가 있으면 false 반환 → 입력 거부
        if value.filter({ $0 == "." }).count > 1 { return false }
        
        // 위 조건을 모두 통과하면 true 반환 → 입력 허용
        return true
    }
}
