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

    func performInitialSyncIfNeeded() {
        let today = DateUtils.todayString()

        firebaseService.fetchRates(for: today)
            .flatMap { model in
                // 이미 오늘자 데이터가 있다면 아무것도 하지 않음
                return Single<Void>.just(())
            }
            .catch { _ in
                // 없다면 API → Firebase 저장
                return self.apiService.fetchRates()
                    .flatMap { model in
                        self.firebaseService.uploadRates(from: model)
                            .andThen(Single.just(())) // 성공한 다음 빈 Single 반환
                    }
            }
            .subscribe(onSuccess: {
                print("환율 동기화 완료")
            }, onFailure: { error in
                print("환율 동기화 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
