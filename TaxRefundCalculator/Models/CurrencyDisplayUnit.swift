//
//  CurrencyDisplayUnit.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 6/13/25.
//

import Foundation

/// 국가별 환산 단위를 담은 딕셔너리
let currencyDisplayUnit: [String: Int] = [
    "JPY": 100,
    "KRW": 1000,
    "MXN": 10,
    "RUB": 10,
    "PHP": 10,
    "ISK": 100,
    "SEK": 10,
    "NOK": 10,
    "CZK": 10,
    "ZAR": 10,
    "TRY": 10,
    "IDR": 10000,
    "HKD": 10,
    "INR": 100,
    "THB": 10,
    "HUF": 100,
]

extension String {
    /// 통화코드에 대응하는 환산 단위 (없으면 1)
    var displayUnit: Int {
        return currencyDisplayUnit[self] ?? 1
    }
}
