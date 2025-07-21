//
//  SavedView.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/28/25.
//

import UIKit
import SnapKit
import Then

final class SavedView: UIView {

    // 상단 요약 배너
    let totalContainer = UIView().then {
        $0.backgroundColor = .mainTeal
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }

    let totalPurchaseLabel = UILabel().then {
        $0.text = NSLocalizedString("Total Purchase Amount", comment: "")
        $0.textColor = .textForGreen
        $0.font = .systemFont(ofSize: 14)
    }

    let totalRefundLabel = UILabel().then {
        $0.text = NSLocalizedString("Total Refund Amount", comment: "")
        $0.textColor = .textForGreen
        $0.font = .systemFont(ofSize: 14)
    }

    let totalPurchaseAmountLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .textForGreen
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 0
    }

    let totalRefundAmountLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .textForGreen
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 0
    }

    let dividerView = UIView().then {
        $0.backgroundColor = UIColor.textForGreen.withAlphaComponent(0.5)
    }
    
    // 총 구매 금액 스택
    private let topStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    // 총 환급 금액 스택
    private let bottomStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    let filterContainer = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.05
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
    }

    let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.text = NSLocalizedString("Base Currency", comment: "")
        $0.textColor = .currency
    }
    
    // 기준통화 선택 버튼
    let currencyButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.title = "▼"
        config.contentInsets = .zero
        config.baseForegroundColor = .mainTeal
        $0.configuration = config
    }
    
    // 날짜 변경 버튼
    let dateRangeButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.title = NSLocalizedString("Select Date", comment: "")
        config.contentInsets = .zero
        config.baseForegroundColor = .mainTeal
        $0.configuration = config
    }

    // 기록 리스트
    let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .bgPrimary
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .bgPrimary

        addSubviews(totalContainer, filterContainer, tableView)
        filterContainer.addSubviews(currencyLabel, currencyButton, dateRangeButton)

        topStack.addArrangedSubviews(totalPurchaseLabel, totalPurchaseAmountLabel)
        bottomStack.addArrangedSubviews(totalRefundLabel, totalRefundAmountLabel)

        totalContainer.addSubviews(topStack, dividerView, bottomStack)

        topStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(topStack.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }

        bottomStack.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }

        totalContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        filterContainer.snp.makeConstraints {
            $0.top.equalTo(totalContainer.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(currencyButton.snp.bottom).offset(16) 
        }

        currencyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        currencyButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(currencyLabel.snp.trailing).offset(4)
        }
        
        dateRangeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(currencyButton)
            $0.leading.greaterThanOrEqualTo(currencyButton.snp.trailing).offset(8)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(filterContainer.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
