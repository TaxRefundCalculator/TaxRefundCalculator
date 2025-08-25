//
//  ExchangeRateAPIService.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 5/8/25.
//

import Foundation
import RxSwift

final class ExchangeRateAPIService {
    private let apiKey = APIKeyManager.currencyAPIKey() ?? ""
    
    func fetchRates() -> Single<ExchangeAPIModel> {
        return Single<ExchangeAPIModel>.create { single in
            guard let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=\(self.apiKey)&base_currency=USD") else {
                single(.failure(NSError(domain: "Invalid URL", code: -1)))
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                guard let data = data else {
                    single(.failure(NSError(domain: "No data", code: -1)))
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                    let today = DateUtils.todayStringUTC()
                    let exchangeRate = ExchangeAPIModel(base: "USD", date: today, rates: decoded.data)
                    single(.success(exchangeRate))
                } catch {
                    single(.failure(error))
                }
            }

            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}

// 내부 응답 모델 (private 유지 권장) - API 응답 전용 모델 (1차 디코딩용)
private struct ExchangeRateResponse: Codable {
    let data: [String: Double]
}
