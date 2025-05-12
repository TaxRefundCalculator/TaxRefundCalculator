//
//  ExchangeVC.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/30/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ExchangeVC: UIViewController {

    // MARK: - Properties

    private let exchangeView = ExchangeView()
    private let disposeBag = DisposeBag()

    /// 더미데이터 VM으로 이동 필요
    private let exchangeRates = BehaviorRelay<[ExchangeRateModel]>(value: [
        ExchangeRateModel(
            flag: "🇺🇸",
            currencyCode: "USD",
            currencyName: "미국 달러",
            formattedRate: "1,320.50",
            diffPercentage: "0.31%",
            isUp: true
        ),
        ExchangeRateModel(
            flag: "🇪🇺",
            currencyCode: "EUR",
            currencyName: "유로",
            formattedRate: "1,420.80",
            diffPercentage: "0.15%",
            isUp: false
        )
    ])

    // MARK: - Lifecycle

    override func loadView() {
        self.view = exchangeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindTableView()
        bindSelection()
        fetchExchangeRates()
    }

    // MARK: - Setup

    private func setupTableView() {
        exchangeView.tableView.register(ExchangeCell.self, forCellReuseIdentifier: ExchangeCell.id)
    }

    private func bindTableView() {
        exchangeRates
            .bind(to: exchangeView.tableView.rx.items(
                cellIdentifier: ExchangeCell.id,
                cellType: ExchangeCell.self)
            ) { row, model, cell in
                cell.bind(model: model)
            }
            .disposed(by: disposeBag)
    }
    
    
    private func bindSelection() {
        exchangeView.tableView.rx
            .modelSelected(ExchangeRateModel.self)
            .bind { [weak self] model in
                let modalVC = ExchangeModalVC()

                modalVC.modalPresentationStyle = .overFullScreen
                modalVC.modalTransitionStyle = .crossDissolve

                // Configure modal with selected model
                modalVC.configure(
                    flag: model.flag,
                    currencyCode: model.currencyCode,
                    currencyName: model.currencyName,
                    currentRate: model.formattedRate,
                    rateDiff: model.diffPercentage,
                    isUp: model.isUp
                )

                self?.present(modalVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    // MARK: - API
    /// 의존성 주입 및 API 분리 필요

    private func fetchExchangeRates() {
        let service = ExchangeRateAPIService()
        service.fetchRates()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] model in
                let converted = model.rates.map {
                    ExchangeRateModel(
                        flag: $0.key.flagEmoji,
                        currencyCode: $0.key,
                        currencyName: $0.key.localizedName,
                        formattedRate: $0.value.roundedString(),
                        diffPercentage: "-",
                        isUp: false
                    )
                }
                self?.exchangeRates.accept(converted)
            }, onFailure: { error in
                print("❌ API 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Utility Extensions

/// Utils 로 이동 및 수정 필요
extension String {
    var flagEmoji: String {
        let base = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        return self.uppercased().unicodeScalars
            .compactMap { UnicodeScalar(base + $0.value)?.description }
            .joined()
    }

    var localizedName: String {
        let locale = Locale.current
        return locale.localizedString(forCurrencyCode: self) ?? self
    }
}

extension Double {
    func roundedString(fractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
