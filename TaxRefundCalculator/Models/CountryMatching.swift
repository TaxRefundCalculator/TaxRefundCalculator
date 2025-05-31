//
//  CountryMatching.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 5/15/25.
//

import Foundation

class CountryMatching: StartPageVC {
    let startPage = StartPageVC()
    let calculatePage = CalculateVC()
    
    func mathingCountry() {
        if ((baseCurrencyField.text?.contains("🇯🇵")) != nil) {
            print("출력")
        }
    }
 
}


