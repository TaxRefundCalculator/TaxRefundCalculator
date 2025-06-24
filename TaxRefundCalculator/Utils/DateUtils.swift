//
//  DateUtils.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 5/9/25.
//

import Foundation

enum DateUtils {
    // 환율탭
    static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: Date())
    }
    
    // 기록탭
    static func toDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter.date(from: dateString)
    }
    
    static func recordString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd HH:mm"
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            return formatter.string(from: Date())
        }
}
