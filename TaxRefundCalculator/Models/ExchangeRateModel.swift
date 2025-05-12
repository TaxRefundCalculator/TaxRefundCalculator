//
//  ExchangeRateModel.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/30/25.
//

import Foundation
import UIKit

struct ExchangeRateModel {
    let flag: String             // 국기
    let currencyCode: String     // 통화
    let currencyName: String
    let formattedRate: String
    let diffPercentage: String
    let isUp: Bool
}
