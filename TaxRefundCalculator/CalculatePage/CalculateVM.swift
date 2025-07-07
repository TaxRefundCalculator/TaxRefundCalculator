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
    
    // MARK: - userDefaults 조회 메서드
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
    
    // MARK: - 유저디폴트에 있는 화폐들, 부가세 띄우기
    // 부가세
    func getVatRate() -> String? {
        return getRefundPolicyByCurrency().map { "\($0.policy.vatRate)%" }
    }
    
    // 여행국가 통화 3글자만 추출
    func getTravelCountry3() -> (full: String, code: String)? {
        guard let currency = getTravelCountry() else { return nil }
        return (currency, String(currency.suffix(3))) // 뒤에서 3글자만 추출
    }
    
    // 기준통화 3글자만 추출
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
    
    // MARK: - 숫자 출력 방식 보정
    /// String -> Double, 다양한 국가별 숫자 포맷을 자동 인식하여 파싱하는 함수
    /// - 사용자가 직접 입력하거나, 외부 API·서버 등에서 받아온 숫자 값이
    ///   각 국가별 포맷(천 단위·소수점 구분자)이 다를 수 있기 때문에
    /// - 우선적으로 사용자의 아이폰 로케일(`Locale.current`)을 사용해 파싱 시도
    /// - 실패 시 대표적인 포맷을 순차적으로 파싱 시도
    func parseLocalizedNumber(_ string: String) -> Double? {
        // 1. 사용자의 기기 설정을 우선 적용하고, 실패시 대표 로케일로 파싱
        let locales = [
            Locale.current,
            Locale(identifier: "en_US"),
            Locale(identifier: "fr_FR"),
            Locale(identifier: "de_DE"),
            Locale(identifier: "it_IT"),
            Locale(identifier: "es_ES")
        ]
        for locale in locales {
            let formatter = NumberFormatter()
            formatter.locale = locale
            formatter.numberStyle = .decimal
            // 각 국가별 표기법(천 단위, 소수점 구분자)에 맞게 파싱
            if let number = formatter.number(from: string) {
                return number.doubleValue
            }
        }
        // 모든 로케일에 실패하면 nil 반환
        return nil
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
    
    // MARK: - 계산 로직
    // 구매금액 변환
    func conversionPrice(priceText: String) -> Double? {
        // 단위 (ex. 1, 10, 100, 1000)
        let travelCurrencyUnit = getTravelCurrencyUnit()
        // 환율값 (String)
        let baseCurrencyValue = getExchangeValue()
        guard
            let price = parseLocalizedNumber(priceText),
            travelCurrencyUnit != 0,
            let baseRate = parseLocalizedNumber(baseCurrencyValue)
        else {
            return nil
        }
        // 환산 공식: (구매금액 / 단위) * 환율
        return price / Double(travelCurrencyUnit) * baseRate
    }
    
    // 환급금액 계산
    func calculateVatRefund(priceText: String) -> Double? {
        guard
            let price = parseLocalizedNumber(priceText),
            let vatString = getVatRate()?.replacingOccurrences(of: "%", with: ""),
            let vat = Double(vatString)
        else { return nil }
        return price * vat / 100
    }

    // 환급금액 변환
    func convertRefundToBaseCurrency(refund: Double) -> Double? {
        let travelCurrencyUnit = getTravelCurrencyUnit()
        let baseCurrencyValue = getExchangeValue()
        guard let baseRate = parseLocalizedNumber(baseCurrencyValue) else { return nil }
        // 환산 공식: (환급금액 / 단위) * 환율
        return refund / Double(travelCurrencyUnit) * baseRate
    }
    
}
