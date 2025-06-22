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
    
    // 여행국가 단위 (ex: 1, 10, 100, 1000)
    func getTravelCurrencyUnit() -> Int {
        saveUserDefaults.getTravelCurrencyUnit()
    }

    // 기준 환율 값 (String)
    func getExchangeValue() -> String {
        saveUserDefaults.getExchangeValue() ?? ""
    }
    
    
    // MARK: 계산 기록 저장하기
    func saveCard(_ card: SavedCard) {
        saveUserDefaults.addCard(card)
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
    
    // MARK: 계산 로직
    // 구매금액 변환
    func conversionPrice(priceText: String) -> Double? {
        // 단위 (ex. 1, 10, 100, 1000)
        let travelCurrencyUnit = getTravelCurrencyUnit()
        // 환율값 (String)
        let baseCurrencyValue = getExchangeValue()
        guard
            let price = Double(priceText),
            travelCurrencyUnit != 0
        else {
            return nil
        }
        // 콤마 제거
        let cleanedBaseCurrency = baseCurrencyValue.replacingOccurrences(of: ",", with: "")
        guard let baseRate = Double(cleanedBaseCurrency) else { return nil }
        // 환산 공식: (구매금액 / 단위) * 환율
        return price / Double(travelCurrencyUnit) * baseRate
    }
    
    // 환급금액 계산
    func calculateVatRefund(priceText: String) -> Double? {
        guard
            let price = Double(priceText),
            let vatString = getVatRate()?.replacingOccurrences(of: "%", with: ""),
            let vat = Double(vatString)
        else { return nil }
        return price * vat / 100
    }

    // 환급금액 변환
    func convertRefundToBaseCurrency(refund: Double) -> Double? {
        let travelCurrencyUnit = getTravelCurrencyUnit()
        let baseCurrencyValue = getExchangeValue()
        let cleanedBaseCurrency = baseCurrencyValue.replacingOccurrences(of: ",", with: "")
        guard let baseRate = Double(cleanedBaseCurrency) else { return nil }
        // 환산 공식: (환급금액 / 단위) * 환율
        return refund / Double(travelCurrencyUnit) * baseRate
    }
    
}
