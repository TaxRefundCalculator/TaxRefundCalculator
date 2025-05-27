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
}

/// TODO
/// 셀 선택 or 꾹 누를 시 편집
/// 슬라이드 삭제
///
