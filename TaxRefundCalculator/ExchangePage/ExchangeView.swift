//
//  ExchangeView.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/30/25.
//

import UIKit
import SnapKit
import Then

final class ExchangeView: UIView {

    // MARK: - UI

    /// 검색 - 네비바 검색으로 변경 예정
    let searchTextField = UITextField().then {
        $0.placeholder = "통화명 또는 국가명 검색"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .bgPrimary
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
        $0.font = .systemFont(ofSize: 15)
    }

    private let titleLabel = UILabel().then {
        $0.text = "실시간 환율정보"
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.textColor = .bodyText
    }
    
    private let refreshLabel = UILabel().then {
        $0.text = "최근갱신일: 2025-04-30"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .currency
    }

    let tableView = UITableView().then {
        $0.separatorStyle = .singleLine
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .bgPrimary
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .subButton
        addSubviews(searchTextField, titleLabel, refreshLabel, tableView)

        searchTextField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(16)
        }
        
        refreshLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
