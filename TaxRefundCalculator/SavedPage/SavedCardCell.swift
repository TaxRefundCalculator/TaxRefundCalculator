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
    
    static let id = "SavedRecordCell"
    
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
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    private let convertedPurchaseLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    private let refundTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.text = "환급 금액"
        $0.textColor = .currency
    }
    
    private let refundAmountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .mainTeal
    }
    
    private let convertedRefundLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .mainTeal
    }
    
    // 구분선
    private let dividerView = UIView().then {
        $0.backgroundColor = .currency.withAlphaComponent(0.3)
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .subButton
        contentView.backgroundColor = .subButton
        
        contentView.addSubview(cardView)
        cardView.addSubviews(
            flagLabel, countryLabel, dateLabel,
            purchaseTitleLabel, purchaseAmountLabel,
            refundTitleLabel, refundAmountLabel,
            dividerView,
            convertedPurchaseLabel, convertedRefundLabel
        )
        
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
        
        purchaseTitleLabel.snp.makeConstraints {
            $0.top.equalTo(flagLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        refundTitleLabel.snp.makeConstraints {
            $0.top.equalTo(purchaseTitleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        purchaseAmountLabel.snp.makeConstraints {
            $0.top.equalTo(purchaseTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(purchaseTitleLabel)
        }
        refundAmountLabel.snp.makeConstraints {
            $0.top.equalTo(refundTitleLabel.snp.bottom).offset(4)
            $0.trailing.equalTo(refundTitleLabel)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(purchaseAmountLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        // 기준화폐
        convertedPurchaseLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(8)
            $0.leading.equalTo(purchaseTitleLabel)
            $0.bottom.equalToSuperview().inset(16)
        }
        convertedRefundLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(8)
            $0.trailing.equalTo(refundTitleLabel)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(with model: SavedCard) {
        flagLabel.text = model.flag
        countryLabel.text = model.country
        dateLabel.text = model.date
        purchaseAmountLabel.text = model.purchaseAmount
        convertedPurchaseLabel.text = "\(model.convertedPurchaseAmount) \(model.convertedCurrency)"
        refundAmountLabel.text = model.refundAmount
        convertedRefundLabel.text = "\(model.convertedRefundAmount) \(model.convertedCurrency)"
    }
}
