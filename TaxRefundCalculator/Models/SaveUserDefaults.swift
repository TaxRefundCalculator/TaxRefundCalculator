//
//  UserDefaults.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 5/17/25.
//

import Foundation

protocol SaveUserDefaultsProtocol { // 캡슐화
    // 정보 저장용
    func saveLanguage(_ language: String)
    func saveBaseCurrency(_ currency: String)
    func saveTravelCountry(_ currency: String)
    func saveIsDoneFirstStep(_ done: Bool)
    // 기록 저장용
    func recordCountry(_ travelCountry: String)
    func recordExchangeRate(_ exchangeRate: Double)
    func recordPrice(_ price: Double)
    func recordRefundPrice(_ refundPrice: Double)
    func recordConversionRefundPrice(_ conversionRefundPrice: Double)
}

class SaveUserDefaults: SaveUserDefaultsProtocol {
    
    // MARK: 정보 저장용
    // 저장
    func saveLanguage(_ language: String) { // 언어
        UserDefaults.standard.set(language, forKey: "selectedLanguage")
    }
    func saveBaseCurrency(_ currency: String) { // 기준 통화
        UserDefaults.standard.set(currency, forKey: "baseCurrency")
    }
    func saveTravelCountry(_ country: String) { // 여행국가
        UserDefaults.standard.set(country, forKey: "travelCountry")
    }
    func saveIsDoneFirstStep(_ done: Bool) { // 초기설정
        UserDefaults.standard.set(done, forKey: "doneFirstStep")
    }
    
    // 불러오기
    func getLanguage() -> String? { // 언어
        return UserDefaults.standard.string(forKey: "selectedLanguage")
    }
    func getBaseCurrency() -> String? { // 기준통화
        return UserDefaults.standard.string(forKey: "baseCurrency")
    }
    func getTravelCountry() -> String? { // 여행국가
        return UserDefaults.standard.string(forKey: "travelCountry")
    }
    func getIsDoneFirstStep() -> Bool { // 초기설정
        return UserDefaults.standard.bool(forKey: "doneFirstStep")
    }
    
    
    // MARK: 기록 저장용
    // 저장
    func recordCountry(_ Country: String) { // 여행국가
        UserDefaults.standard.set(Country, forKey: "recordCountry")
    }
    func recordExchangeRate(_ exchangeRate: Double) { // 환율
        UserDefaults.standard.set(exchangeRate, forKey: "recordExchangeRate")
    }
    func recordPrice(_ price: Double) { // 구매 금액
        UserDefaults.standard.set(price, forKey: "recordPrice")
    }
    func recordRefundPrice(_ refundPrice: Double) { // 환급액
        UserDefaults.standard.set(refundPrice, forKey: "recordRefundPrice")
    }
    func recordConversionRefundPrice(_ conversionRefundPrice: Double) { // 환급액 기준화폐로 변환
        UserDefaults.standard.set(conversionRefundPrice, forKey: "recordConversionRefundPrice")
    }
    
    // 불러오기
    func getCountry() -> String? { // 여행국가
        return UserDefaults.standard.string(forKey: "recordCountry")
    }
    func getExchangeRate() -> Double? { // 환율
        return UserDefaults.standard.double(forKey: "recordExchangeRate")
    }
    func getPrice() -> Double? { // 구매 금액
        return UserDefaults.standard.double(forKey: "recordPrice")
    }
    func getRefundPrice() -> Double? { // 환급액
        return UserDefaults.standard.double(forKey: "recordRefundPrice")
    }
    func getConversionRefundPrice() -> Double? { // 환급액 기준화폐로 변환
        return UserDefaults.standard.double(forKey: "recordConversionRefundPrice")
    }
}
