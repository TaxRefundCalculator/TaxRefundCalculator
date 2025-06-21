//
//  SavedVC.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/28/25.
//

import UIKit
import RxSwift
import RxCocoa
import Fastis

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
        bindSelection()
        bindTotalAmount()
        
        // 선택된 날짜를 dateRangeLabel에 바인딩
        viewModel.selectedDateRange
            .map { range in
                if let start = range.0, let end = range.1 {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy.MM.dd"
                    return "\(formatter.string(from: start)) ~ \(formatter.string(from: end))"
                } else {
                    return "전체"
                }
            }
            .bind(to: savedView.dateRangeLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 날짜 선택 UI 연결
        savedView.changeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showDatePicker()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadSavedCards() // 기록 새로 불러오기
    }
    
    private func bindTableView() {
        savedView.tableView.register(SavedCardCell.self, forCellReuseIdentifier: SavedCardCell.id)
        
        viewModel.filteredCards
            .bind(to: savedView.tableView.rx.items(cellIdentifier: SavedCardCell.id, cellType: SavedCardCell.self)) { [weak self] row, model, cell in
                cell.configure(with: model) { [weak self] in
                            self?.showDeleteAlert(for: model)
                        }
                    }
            .disposed(by: disposeBag)
    }
    
    private func bindSelection() {
        savedView.tableView.rx.modelSelected(SavedCard.self)
            .bind { [weak self] model in
                let modalVC = SavedModalVC()
                modalVC.savedCard = model
                
                modalVC.modalPresentationStyle = .overFullScreen
                modalVC.modalTransitionStyle = .crossDissolve
                
                self?.present(modalVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    // 총합 계산
    private func bindTotalAmount() {
        viewModel.filteredCards
            .map { cards in
                let totalPurchase = cards.reduce(0) { $0 + $1.convertedPrice }
                let totalRefund = cards.reduce(0) { $0 + $1.convertedRefundPrice }
                let currency = cards.first?.baseCurrencyCode ?? ""
//                let currency = ""
                return ("\(totalPurchase) \(currency)", "\(totalRefund) \(currency)")
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] purchase, refund in
                self?.savedView.totalPurchaseAmountLabel.text = purchase
                self?.savedView.totalRefundAmountLabel.text = refund
            })
            .disposed(by: disposeBag)
    }
    
    private func showDatePicker() {
        let fastisController = FastisController(mode: .range)
        fastisController.title = "날짜 선택"
        fastisController.allowToChooseNilDate = true
        fastisController.maximumDate = Date() // 오늘까지 선택 가능
        fastisController.dismissHandler = { [weak self] action in
            switch action {
            case .done(let range):
                if let range = range {
                    self?.viewModel.setDateRange(start: range.fromDate, end: range.toDate)
                } else {
                    // 날짜 미선택 시 전체보기
                    self?.viewModel.setDateRange(start: nil, end: nil)
                }
            case .cancel:
                break
            }
        }
        fastisController.present(above: self)
    }
    
    // 알럿
    private func showDeleteAlert(for card: SavedCard) {
        let alert = UIAlertController(
            title: "기록 삭제",
            message: "해당 기록을 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteCard(withId: card.id)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

/// TODO
/// 셀 선택 or 꾹 누를 시 편집
/// 슬라이드 삭제
///
