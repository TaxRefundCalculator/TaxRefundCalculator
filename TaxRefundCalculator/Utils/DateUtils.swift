//
//  DateUtils.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 5/9/25.
//

import Foundation

enum DateUtils {
    static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: Date())
    }
}
