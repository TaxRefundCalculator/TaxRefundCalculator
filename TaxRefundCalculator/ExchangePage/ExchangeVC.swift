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
    private let viewModel: ExchangeVM

    init(viewModel: ExchangeVM = ExchangeVM(apiService: ExchangeRateAPIService(), firebaseService: FirebaseExchangeService())) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        self.view = exchangeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindTableView()
        bindRefreshButton()
        bindUpdateDateLabel()
        viewModel.fetchExchangeRates()
    }

    // MARK: - Setup, binding

    private func setupTableView() {
        exchangeView.tableView.register(ExchangeCell.self, forCellReuseIdentifier: ExchangeCell.id)
    }

    private func bindTableView() {
        viewModel.exchangeRates
            .bind(to: exchangeView.tableView.rx.items(
                cellIdentifier: ExchangeCell.id,
                cellType: ExchangeCell.self)
            ) { row, model, cell in
                cell.bind(model: model)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUpdateDateLabel() {
        viewModel.latestUpdateDate
            .map { "최근갱신일: \($0)" }
            .bind(to: exchangeView.refreshLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    /// 갱신, 업로드
    private func bindRefreshButton() {
        exchangeView.refreshButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel.uploadRatesToFirebase()
            }
            .disposed(by: disposeBag)
    }
}
