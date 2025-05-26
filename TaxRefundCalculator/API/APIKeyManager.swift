//
//  APIKeyManager.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 5/8/25.
//

import Foundation

enum APIKeyManager {
    static func currencyAPIKey() -> String? {
        guard let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["CurrencyAPIKey"] as? String else {
            return nil
        }
        return key
    }
}
