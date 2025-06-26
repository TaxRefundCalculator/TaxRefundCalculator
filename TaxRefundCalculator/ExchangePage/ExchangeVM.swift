//
//  ExchangeVM.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/30/25.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

class ExchangeVM {
    private let apiService: ExchangeRateAPIService
    private let firebaseService: FirebaseExchangeService
    
    /// 설정탭 컴바인 연동 부분 - 통일 필요
    private var cancellables = Set<AnyCancellable>()
    private let settingVM = SettingVM.shared
    
    // 기준화폐 - 유저디폴트에서 추출
    private var baseCurrency: String = {
        let saved = SaveUserDefaults().getBaseCurrency() ?? "USD"
        return String(saved.suffix(3))
    }()
    
    // 바인딩 관련 Relay
    let exchangeRates = BehaviorRelay<[ExchangeRateModel]>(value: [])
    let latestUpdateDate = BehaviorRelay<String>(value: "") // 갱신날짜
    private let disposeBag = DisposeBag()

    init(apiService: ExchangeRateAPIService, firebaseService: FirebaseExchangeService) {
        self.apiService = apiService
        self.firebaseService = firebaseService
        
        /// 기준통화 변경되면 자동으로 환율 갱신 - Combine
        settingVM.$baseCurrency
            .removeDuplicates()
            .sink { [weak self] value in
                guard !value.isEmpty else { return }
                let code = String(value.suffix(3)) // 항상 3자리 코드로 변환
                self?.baseCurrency = code
                self?.fetchExchangeRates()
            }
            .store(in: &cancellables)
    }
    
    /// 파이어베이스에서 받아오기
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

        let models: [ExchangeRateModel] = model.rates
            .filter { !excludedCodes.contains($0.key) }
            .map { (code, _) -> ExchangeRateModel in
                let unit = code.displayUnit
                var value: Double = 0
                if code == baseCurrency {
                    value = Double(unit)
                } else if let baseToBase = model.rates[baseCurrency], let baseToCode = model.rates[code] {
                    value = baseToBase / baseToCode * Double(unit)
                }
                
                /// 환율 표시 ex) 1 USD = 123.45 KRW
                let formatted = (unit > 1 ? "\(unit) \(code)" : "1 \(code)") + " = " + value.roundedString(fractionDigits: 2) + " \(baseCurrency)"
                return ExchangeRateModel(
                    flag: code.flagEmoji,
                    currencyCode: code,
                    formattedRate: formatted
                )
            }
            .sorted { (a, b) in  /// 우선순위 정렬
                let idx1 = priorityCodes.firstIndex(of: a.currencyCode) ?? Int.max
                let idx2 = priorityCodes.firstIndex(of: b.currencyCode) ?? Int.max
                return idx1 < idx2
            }
        self.exchangeRates.accept(models)
        self.latestUpdateDate.accept(model.date)
    }
}
