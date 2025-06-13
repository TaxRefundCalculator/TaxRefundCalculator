//
//  String+FlagEmoji.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 5/16/25.
//

import Foundation

/// 국기 이모지 생성 유틸리티
extension String {
    var flagEmoji: String {
        let base: UInt32 = 127397
        let uppercased = self.uppercased()
        let countryCode = String(uppercased.prefix(2))

        let scalars = countryCode.unicodeScalars.compactMap {
            UnicodeScalar(base + $0.value)
        }
        return scalars.map { String($0) }.joined()
    }
}
