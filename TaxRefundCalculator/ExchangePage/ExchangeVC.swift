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
}
