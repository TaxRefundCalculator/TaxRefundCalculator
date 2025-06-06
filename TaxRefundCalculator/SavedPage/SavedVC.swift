//
//  SavedVC.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/28/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SavedVC: UIViewController {

    private let savedView = SavedView()
    private let disposeBag = DisposeBag()
    private let viewModel = SavedVM()

    override func loadView() {
        view = savedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView()
        bindTotalAmount()
        viewModel.saveMockData()
    }

    private func bindTableView() {
        savedView.tableView.register(SavedRecordCell.self, forCellReuseIdentifier: SavedRecordCell.id)

        viewModel.savedCards
            .bind(to: savedView.tableView.rx.items(cellIdentifier: SavedRecordCell.id, cellType: SavedRecordCell.self)) { row, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
    }
    
    // 총합 계산
    private func bindTotalAmount() {
        viewModel.savedCards
            .map { cards in
                let totalPurchase = cards.reduce(0) { $0 + $1.convertedPurchaseAmount }
                let totalRefund = cards.reduce(0) { $0 + $1.convertedRefundAmount }
                let currency = cards.first?.convertedCurrency ?? "KRW"
                return ("\(totalPurchase) \(currency)", "\(totalRefund) \(currency)")
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] purchase, refund in
                self?.savedView.totalPurchaseAmountLabel.text = purchase
                self?.savedView.totalRefundAmountLabel.text = refund
            })
            .disposed(by: disposeBag)
    }
}

/// TODO
/// 셀 선택 or 꾹 누를 시 편집
/// 슬라이드 삭제
///
