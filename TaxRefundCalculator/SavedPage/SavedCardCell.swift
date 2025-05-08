//
//  SavedCardCell.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/29/25.
//

import UIKit
import SnapKit
import Then

final class SavedRecordCell: UITableViewCell {

    static let identifier = "SavedRecordCellView"

    private let cardView = UIView().then {
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.05
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
    }

    // 국기
    private let flagLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
    }

    // 나라이름
    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }

    // 날짜
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .light)
        $0.textColor = .currency
    }

    private let purchaseTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.text = "구매 금액"
        $0.textColor = .currency
    }

    private let purchaseAmountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }

    private let refundTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.text = "환급 금액"
        $0.textColor = .currency
    }

    private let refundAmountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .mainTeal
    }

    // 구매 금액 스택
    private let leftStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    // 환급 금액 스택
    private let rightStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .trailing
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .bgPrimary
        contentView.backgroundColor = .bgSecondary

        contentView.addSubview(cardView)
        cardView.addSubviews(flagLabel, countryLabel, dateLabel, leftStack, rightStack)

        leftStack.addArrangedSubviews(purchaseTitleLabel, purchaseAmountLabel)
        rightStack.addArrangedSubviews(refundTitleLabel, refundAmountLabel)

        cardView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }

        flagLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }

        countryLabel.snp.makeConstraints {
            $0.leading.equalTo(flagLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(flagLabel)
        }

        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(flagLabel)
        }

        leftStack.snp.makeConstraints {
            $0.top.equalTo(flagLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }

        rightStack.snp.makeConstraints {
            $0.centerY.equalTo(leftStack)
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    func configure(with model: SavedCard) {
        flagLabel.text = model.flag
        countryLabel.text = model.country
        dateLabel.text = model.date
        purchaseAmountLabel.text = model.purchaseAmount
        refundAmountLabel.text = model.refundAmount
    }
}
