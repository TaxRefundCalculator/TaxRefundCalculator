//
//  ExchangeSyncManager.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 6/16/25.
//

import Foundation
import RxSwift

final class ExchangeSyncManager {
    static let shared = ExchangeSyncManager()
    
    private let apiService = ExchangeRateAPIService()
    private let firebaseService = FirebaseExchangeService()
    private let disposeBag = DisposeBag()
    
    private init() {}
    
    func performInitialSyncIfNeeded() -> Single<Void> {
        let today = DateUtils.todayString()
        
        return firebaseService.fetchRates(for: today)
            .flatMap { _ in
                // 이미 오늘자 데이터 있음 → 아무것도 안 함
                Single.just(())
            }
            .catch { _ in
                // 없음 → API요청 → Firebase 저장
                self.apiService.fetchRates()
                    .flatMap { model in
                        self.firebaseService.uploadRates(from: model)
                            .andThen(Single.just(()))
                    }
            }
            .do(onSuccess: {
                print("환율 동기화, 업데이트 완료")
            }, onError: { error in
                print("환율 동기화 실패: \(error.localizedDescription)")
            })
    }
}
