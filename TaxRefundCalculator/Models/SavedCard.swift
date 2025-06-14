//
//  SavedCard.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/30/25.
//

import Foundation

struct SavedCard: Codable {
    // 임시로 모든값은 String. 추후 가격, 환급액, 기준화폐로 변환된 환급액 부분은 더블로 변경해야함
    let country: String
    let exchangeRate: String
    let price: Double
    let refundPrice: Double
    let convertedRefundPrice: Double
}
