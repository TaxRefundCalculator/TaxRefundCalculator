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

    private let dummyData = [
        SavedCard(
            flag: "🇫🇷",
            country: "프랑스",
            date: "2025.04.10",
            purchaseAmount: "500 EUR",
            refundAmount: "83.33 EUR"
        ),
        SavedCard(
            flag: "🇯🇵",
            country: "일본",
            date: "2025.03.25",
            purchaseAmount: "40,000 JPY",
            refundAmount: "3,636 JPY"
        ),
        SavedCard(
            flag: "🇪🇸",
            country: "스페인",
            date: "2025.02.12",
            purchaseAmount: "300 EUR",
            refundAmount: "50 EUR"
        )
    ]

    override func loadView() {
        view = savedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        savedView.tableView.register(SavedRecordCell.self, forCellReuseIdentifier: SavedRecordCell.identifier)

        Observable.just(dummyData)
            .bind(to: savedView.tableView.rx.items(cellIdentifier: SavedRecordCell.identifier, cellType: SavedRecordCell.self)) { row, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
    }
}
