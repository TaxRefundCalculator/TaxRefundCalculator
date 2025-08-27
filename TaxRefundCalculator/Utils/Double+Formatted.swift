//
//  Double+Formatted.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 5/16/25.
//

import Foundation

// MARK: -  Double 타입 숫자를 로케일(국가별 설정)에 맞게 문자열로 변환해주는 유틸리티
extension Double {
    /// 소수점 이하 자리수를 지정하여, 사용자의 Locale(국가 설정)에 맞는 숫자 문자열로 변환
    /// - Parameter fractionDigits: 표시할 소수점 이하 자리수(기본값: 2)
    /// - Returns: 천 단위 구분자, 소수점 처리 등이 반영된 문자열 (예: 1,234.56, 1.234,56 등)
    func roundedString(fractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 천 단위 구분자, 소수점 등 국가별 스타일 적용
        formatter.locale = Locale.current // 현재 사용자의 아이폰 설정 로케일을 자동 적용
        formatter.minimumFractionDigits = 0 // 0이면 소수점 이하가 모두 0일 때는 표시하지 않음
        formatter.maximumFractionDigits = fractionDigits
        let number = NSNumber(value: self)
        var string = formatter.string(from: number) ?? "\(self)"
        
        // 아래는 “뒷자리에 소수점이 0만 남았을 때 표시하지 않도록” 추가 가공
        if let decimalSeparator = formatter.decimalSeparator, string.contains(decimalSeparator) {
            // 소수점 이하가 0이면 0을 하나씩 제거 (예: 1,230.00 → 1,230)
            while string.last == "0" {
                string.removeLast()
            }
            // 소수점만 남았으면 소수점 기호 자체도 제거 (예: 1,230. → 1,230)
            if string.last == Character(decimalSeparator) {
                string.removeLast()
            }
        }
        return string
    }
}
