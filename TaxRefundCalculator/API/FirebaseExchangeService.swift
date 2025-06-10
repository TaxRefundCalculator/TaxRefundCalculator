//
//  FirebaseExchangeService.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/30/25.
//

import Foundation
import FirebaseFirestore
import RxSwift

/// 파이어베이스 API

final class FirebaseExchangeService {
    private let db: Firestore
    
    init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }
    
    func uploadRates(_ rates: [ExchangeRateModel]) {
        let today = DateUtils.todayString()
        let batch = db.batch()
        
        for rate in rates {
            let docRef = db.collection("exchangeRates").document(today).collection("rates").document(rate.currencyCode)
            let data: [String: Any] = [
                "currencyCode": rate.currencyCode,
                "currencyName": rate.currencyName,
                "flag": rate.flag,
                "formattedRate": rate.formattedRate
            ]
            batch.setData(data, forDocument: docRef)
        }
        
        batch.commit { error in
            if let error = error {
                print("❌ Firestore 저장 실패: \(error.localizedDescription)")
            } else {
                print("✅ Firestore 저장 완료")
            }
        }
    }
    
    /// 파이어베이스에 저장된 데이터 읽어오기 (Rx 버전)
    func fetchRates(for date: String) -> Single<ExchangeAPIModel> {
        return Single.create { single in
            let docRef = self.db.collection("exchangeRates").document(date)
            docRef.getDocument { snapshot, error in
                if let error = error {
                    single(.failure(error))
                } else if
                    let data = snapshot?.data(),
                    let base = data["base"] as? String,
                    let date = data["date"] as? String,
                    let rates = data["rates"] as? [String: Double] {
                    let model = ExchangeAPIModel(base: base, date: date, rates: rates)
                    single(.success(model))
                } else {
                    single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found."])))
                }
            }
            return Disposables.create()
        }
    }
    
    func uploadRates(from model: ExchangeAPIModel) {
        let docRef = db.collection("exchangeRates").document(model.date)
        let data: [String: Any] = [
            "base": model.base,
            "date": model.date,
            "rates": model.rates
        ]
        docRef.setData(data) { error in
            if let error = error {
                print("❌ Firestore 저장 실패: \(error.localizedDescription)")
            } else {
                print("✅ Firestore에 API 모델 저장 완료")
            }
        }
    }
    
    /// 최신 데이터 읽어오기 (Rx 버전)
    func fetchLatestRates() -> Single<ExchangeAPIModel> {
        return Single.create { single in
            self.db.collection("exchangeRates")
                .order(by: "date", descending: true)
                .limit(to: 1)
                .getDocuments { snapshot, error in
                    if let error = error {
                        single(.failure(error))
                        return
                    }
                    
                    guard let doc = snapshot?.documents.first else {
                        single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No recent data found."])))
                        return
                    }
                    
                    let data = doc.data()
                    guard let base = data["base"] as? String,
                          let date = data["date"] as? String,
                          let rates = data["rates"] as? [String: Double] else {
                        single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No recent data found."])))
                        return
                    }
                    
                    let model = ExchangeAPIModel(base: base, date: date, rates: rates)
                    single(.success(model))
                }
            
            return Disposables.create()
        }
    }
}
