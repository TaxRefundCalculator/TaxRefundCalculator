//
//  ExchangeVM.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/30/25.
//

import Foundation
import RxSwift
import RxCocoa

class ExchangeVM {
    private let apiService: ExchangeRateAPIService
    private let firebaseService: FirebaseExchangeService
    let exchangeRates = BehaviorRelay<[ExchangeRateModel]>(value: [])
    let latestUpdateDate = BehaviorRelay<String>(value: "") // 갱신날짜
    private let disposeBag = DisposeBag()

    init(apiService: ExchangeRateAPIService, firebaseService: FirebaseExchangeService) {
        self.apiService = apiService
        self.firebaseService = firebaseService
    }

    /// 파이어베이스에서 받아오기 (Rx 버전)
    func fetchExchangeRates() {
        let today = DateUtils.todayString()
        firebaseService.fetchRates(for: today)
            .catch { _ in self.firebaseService.fetchLatestRates() }
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] model in
                self?.applyToRelay(model: model)
            }, onFailure: { error in
                print("❌ 환율 불러오기 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    /// 받아온 데이터 표시하기
    private func applyToRelay(model: ExchangeAPIModel) {
        let priorityCodes = ["USD", "EUR", "JPY", "KRW", "GBP", "AUD", "CAD"]
        let excludedCodes: Set<String> = ["CNY"] // 제외할 통화 걸러내기

        let models = model.rates
            .filter { !excludedCodes.contains($0.key) }
            .map {
                ExchangeRateModel(
                    flag: $0.key.flagEmoji,
                    currencyCode: $0.key,
                    currencyName: $0.key.localizedName,
                    formattedRate: $0.value.roundedString(),
                    diffPercentage: "-",  /// TODO - 로직, 구현필요
                    isUp: false
                )
            }
            .sorted {
                // 우선순위 위주로 정렬
                let idx1 = priorityCodes.firstIndex(of: $0.currencyCode) ?? Int.max
                let idx2 = priorityCodes.firstIndex(of: $1.currencyCode) ?? Int.max
                return idx1 < idx2
            }

        self.exchangeRates.accept(models)
        self.latestUpdateDate.accept(model.date)
    }

    /// 파이어베이스에 데이터 업로드하기
    func uploadRatesToFirebase() {
        apiService.fetchRates() // API 요청
            .subscribe(onSuccess: { [weak self] newRates in
                guard let self = self else { return }
                self.firebaseService.uploadRates(from: newRates)
                self.fetchExchangeRates()
            }, onFailure: { error in
                print("❌ API 요청 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
