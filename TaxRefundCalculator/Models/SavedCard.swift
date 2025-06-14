//
//  SavedCard.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/30/25.
//

import Foundation

struct SavedCard: Codable {
    // 임시로 모든값은 String. 추후 가격, 환급액, 기준화폐로 변환된 환급액 부분은 더블로 변경해야함
    
    // 국기 + 국가 + 코드
    let country: String
    // 환율
    let exchangeRate: String
    // 날짜
    let date: String
    // 구매금액
    let price: Double
    // 환급 금액
    let refundPrice: Double
    // 구매금액 환산된거
    // 환급 금액 - 변환 된거
    let convertedRefundPrice: Double
}
