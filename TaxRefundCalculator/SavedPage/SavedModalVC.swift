//
//  SavedModalVC.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 6/14/25.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

final class SavedModalVC: UIViewController {
    
    var savedCard: SavedCard?
    
    // 뷰모델 선언
    let viewModel = CalculateVM()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 20
    }
    
    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
    }
    
    private let vatLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
    }
    
    // 날짜
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .light)
        $0.textColor = .primaryText
    }
    
    private let purchaseTitleLabel = UILabel().then {
        $0.text = NSLocalizedString("Purchase Amount", comment: "")
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .primaryText
    }
    
    private let purchaseAmountLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    private let convertedPurchaseLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    private let refundTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.text = NSLocalizedString("Refund Amount", comment: "")
        $0.textColor = .primaryText
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
    
    private let refundConditionView = UIView().then {
        $0.backgroundColor = .subButton
        $0.layer.cornerRadius = 12
    }
    
    private let rateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.text = NSLocalizedString("Applied Exchange Rate :", comment: "")
        $0.textColor = .primaryText
    }
    
    private let exchangeRateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .primaryText
    }
    
    private let conditionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let dismissButton = UIButton(type: .system).then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainTeal
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 10
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        view.addSubview(containerView)
        refundConditionView.addSubviews(rateLabel, exchangeRateLabel, conditionLabel)
        
        containerView.addSubviews(
            countryLabel, vatLabel, dateLabel,
            purchaseTitleLabel, purchaseAmountLabel,
            refundTitleLabel, refundAmountLabel,
            dividerView,
            convertedPurchaseLabel, convertedRefundLabel,
            refundConditionView,
            dismissButton
        )
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 상단 정보 (국기, 국가명, 날짜)
        countryLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(countryLabel)
        }
        
        vatLabel.snp.makeConstraints {
            $0.top.equalTo(countryLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
        }
        
        // 구매/환급 타이틀
        purchaseTitleLabel.snp.makeConstraints {
            $0.top.equalTo(vatLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        refundTitleLabel.snp.makeConstraints {
            $0.top.equalTo(purchaseTitleLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        // 구매/환급 금액
        purchaseAmountLabel.snp.makeConstraints {
            $0.top.equalTo(purchaseTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(purchaseTitleLabel)
        }
        refundAmountLabel.snp.makeConstraints {
            $0.top.equalTo(refundTitleLabel.snp.bottom).offset(4)
            $0.trailing.equalTo(refundTitleLabel)
        }
        
        // 구분선
        dividerView.snp.makeConstraints {
            $0.top.equalTo(purchaseAmountLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(1)
        }
        
        // 기준화폐 금액
        convertedPurchaseLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(8)
            $0.leading.equalTo(purchaseTitleLabel)
        }
        convertedRefundLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(8)
            $0.trailing.equalTo(refundTitleLabel)
        }
        
        refundConditionView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(convertedPurchaseLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        rateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        exchangeRateLabel.snp.makeConstraints {
            $0.leading.equalTo(rateLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(rateLabel)
        }
        
        conditionLabel.snp.makeConstraints {
            $0.top.equalTo(rateLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(refundConditionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        dismissButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        guard let card = savedCard, let (_, policy) = viewModel.getRefundPolicyByCurrency() else { return }
        
        let countryWithCurrency = card.country
        let parts = countryWithCurrency.components(separatedBy: " - ")
        let countryName = parts.first ?? ""    // "태국"
        let currencyCode = parts.last ?? ""    // "THB"
        
        countryLabel.text = countryName
        dateLabel.text = card.date // 예: "2024-06-15" 등 (모델에 맞게)
        purchaseAmountLabel.text = "\(card.price) \(currencyCode)" // 예: "100,000 KRW"
        refundAmountLabel.text = "\(card.refundPrice) \(currencyCode)" // 예: "7,000 KRW"
        
        convertedPurchaseLabel.text = "\(card.convertedRefundPrice) \(card.baseCurrencyCode)" // 예: "75.22 USD"
        convertedRefundLabel.text = "\(card.convertedRefundPrice) \(card.baseCurrencyCode)" // 예: "5.27 USD"
        
        exchangeRateLabel.text = card.exchangeRate
        conditionLabel.text = """
        💰 VAT율 :  \(policy.vatRate)%\n
        💵 최소 구매금액 :  \(Int(policy.minimumAmount)) \(policy.currencyCode)\n
        🔁 환급 방법 :  \(policy.refundMethod)\n
        📍 환급 장소 :  \(policy.refundPlace)\n
        📌 비고 :  \(policy.notes)
        """
    }
}
