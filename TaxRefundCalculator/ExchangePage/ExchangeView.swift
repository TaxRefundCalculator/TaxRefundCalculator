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

    private let titleLabel = UILabel().then {
        $0.text = "실시간 환율정보"
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.textColor = .primaryText
    }
    
    let refreshLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .currency
    }

    let tableView = UITableView().then {
        $0.separatorStyle = .singleLine
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .bgSecondary
        $0.rowHeight = 52
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.allowsSelection = false
    }
    
    private let tableContainerView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
        $0.clipsToBounds = false
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
        backgroundColor = .bgPrimary
        addSubviews(titleLabel, refreshLabel, tableContainerView)
        tableContainerView.addSubview(tableView)


        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        refreshLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        tableContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
}
