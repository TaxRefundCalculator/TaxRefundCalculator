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
        $0.textColor = .bgPrimary
        $0.font = .systemFont(ofSize: 14)
    }

    let totalRefundLabel = UILabel().then {
        $0.text = "총 환급 금액"
        $0.textColor = .bgPrimary
        $0.font = .systemFont(ofSize: 14)
    }

    let totalPurchaseAmountLabel = UILabel().then {
        $0.text = "0 EUR"
        $0.textColor = .bgPrimary
        $0.font = .boldSystemFont(ofSize: 20)
    }

    let totalRefundAmountLabel = UILabel().then {
        $0.text = "0 EUR"
        $0.textColor = .bgPrimary
        $0.font = .boldSystemFont(ofSize: 20)
    }

    let dividerView = UIView().then {
        $0.backgroundColor = UIColor.bgPrimary.withAlphaComponent(0.5)
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
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.05
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
    }

    // 날짜 선택 버튼
    let filterButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.title = "2025년 3월 xx일"
        config.baseForegroundColor = .label
        config.image = UIImage(systemName: "line.horizontal.3.decrease.circle")
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        $0.configuration = config
        $0.contentHorizontalAlignment = .left
    }

    // 기록 리스트
    let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .bgSecondary
        $0.allowsSelection = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .bgSecondary

        addSubviews(totalContainer, filterContainer, tableView)
        filterContainer.addSubviews(filterButton)

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

        filterButton.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(filterContainer.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
