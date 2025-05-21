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
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
