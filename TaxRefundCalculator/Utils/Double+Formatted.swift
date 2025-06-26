//
//  Double+Formatted.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 5/16/25.
//

import Foundation

/// 숫자 표시 포맷 유틸
extension Double {
    func roundedString(fractionDigits: Int = 2) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale.current
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = fractionDigits
            let number = NSNumber(value: self)
        var string = formatter.string(from: number) ?? "\(self)"
        
        // 소수점이 0만 남으면 제거
        if let decimalSeparator = formatter.decimalSeparator, string.contains(decimalSeparator) {
            while string.last == "0" {
                string.removeLast()
            }
            if string.last == Character(decimalSeparator) {
                string.removeLast()
            }
        }
        return string
    }
}
