//
//  SavedCardCell.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/29/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SavedCardCell: UITableViewCell {
    
    static let id = "SavedCardCell"
    
    var disposeBag = DisposeBag()
    let deleteButtonTapped = PublishRelay<Void>()
    private var deleteHandler: (() -> Void)?
    
    private let cardView = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
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
    
    // 삭제버튼
    private let deleteButton = UIButton(type: .system).then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        let image = UIImage(systemName: "trash", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .currency
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
    }

    private let purchaseTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.text = NSLocalizedString("Purchase Amount", comment: "")
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
        $0.text = NSLocalizedString("Refund Amount", comment: "")
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
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        deleteHandler = nil
    }
    
    // Rx 이벤트 바인딩
    private func bind() {
        deleteButton.rx.tap
            .bind(to: deleteButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .bgSecondary
        contentView.backgroundColor = .bgPrimary
        
        contentView.addSubview(cardView)
        cardView.addSubviews(
            countryLabel, dateLabel, deleteButton,
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
        
        countryLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-8)
            $0.centerY.equalTo(countryLabel)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(countryLabel)
        }
        
        // 구매 금액 타이틀 좌측 상단
        purchaseTitleLabel.snp.makeConstraints {
            $0.top.equalTo(countryLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        // 환급 금액 타이틀 우측 상단
        refundTitleLabel.snp.makeConstraints {
            $0.top.equalTo(purchaseTitleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        // 구매 금액 라벨 좌측
        purchaseAmountLabel.snp.makeConstraints {
            $0.top.equalTo(purchaseTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(purchaseTitleLabel)
        }
        // 환급 금액 라벨 우측
        refundAmountLabel.snp.makeConstraints {
            $0.top.equalTo(refundTitleLabel.snp.bottom).offset(4)
            $0.trailing.equalTo(refundTitleLabel)
        }
        
        // 구분선은 두 금액 라벨 아래 가로로 길게
        dividerView.snp.makeConstraints {
            $0.top.equalTo(purchaseAmountLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        // 기준화폐 금액 표시용 라벨들 각각 구매/환급 금액 하단 좌우에 위치
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
    
    func configure(with model: SavedCard, onDelete: @escaping () -> Void) {
        let countryWithCurrency = model.country
        let parts = countryWithCurrency.components(separatedBy: " - ")
        let countryName = parts.first ?? ""    // "태국"
        let currencyCode = parts.last ?? ""    // "THB"
        countryLabel.text = countryName
        dateLabel.text = model.date
        purchaseAmountLabel.text = "\(model.price.roundedString()) \(currencyCode)"
        convertedPurchaseLabel.text = "\(model.convertedPrice.roundedString()) \(model.baseCurrencyCode)"
        refundAmountLabel.text = "\(model.refundPrice.roundedString()) \(model.country.suffix(3))"
        convertedRefundLabel.text = "\(model.convertedRefundPrice.roundedString()) \(model.baseCurrencyCode)"
        // 삭제 핸들러
        self.deleteHandler = onDelete
        bindDeleteButton()
    }
    
    private func bindDeleteButton() {
            deleteButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.deleteHandler?()
                })
                .disposed(by: disposeBag)
        }
}
