//
//  ExchangeRate.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 5/8/25.
//

import Foundation

/// API 환율 모델 (앱 내부에서 사용하는 통합 환율 모델)
struct ExchangeAPIModel: Codable {
    let base: String
    let date: String
    let rates: [String: Double]
}
