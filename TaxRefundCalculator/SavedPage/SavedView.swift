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
    }

    let totalPurchaseLabel = UILabel().then {
        $0.text = "총 구매 금액"
        $0.textColor = .textForGreen
        $0.font = .systemFont(ofSize: 14)
    }

    let totalRefundLabel = UILabel().then {
        $0.text = "총 환급 금액"
        $0.textColor = .textForGreen
        $0.font = .systemFont(ofSize: 14)
    }

    let totalPurchaseAmountLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .textForGreen
        $0.font = .boldSystemFont(ofSize: 20)
    }

    let totalRefundAmountLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .textForGreen
        $0.font = .boldSystemFont(ofSize: 20)
    }

    let dividerView = UIView().then {
        $0.backgroundColor = UIColor.textForGreen.withAlphaComponent(0.5)
    }
    
    // 총 구매 금액 스택
    private let leftStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    // 총 환급 금액 스택
    private let rightStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .trailing
    }

    let filterContainer = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.05
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
    }

    let dateRangeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    // 날짜 변경 버튼
    let changeButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.title = "날짜 변경"
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
        filterContainer.addSubviews(dateRangeLabel, changeButton)

        leftStack.addArrangedSubviews(totalPurchaseLabel, totalPurchaseAmountLabel)
        rightStack.addArrangedSubviews(totalRefundLabel, totalRefundAmountLabel)

        totalContainer.addSubviews(leftStack, dividerView, rightStack)

        leftStack.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        dividerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(40)
        }

        rightStack.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        totalContainer.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(80)
        }

        filterContainer.snp.makeConstraints {
            $0.top.equalTo(totalContainer.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }

        dateRangeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        changeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(filterContainer.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
