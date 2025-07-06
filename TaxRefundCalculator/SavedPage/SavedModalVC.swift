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
    
    private let viewModel : SavedModalVM
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 20
    }
    
    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
    }
    
    // 날짜
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .light)
        $0.textColor = .primaryText
    }
    
    private let purchaseTitleLabel = UILabel().then {
        $0.text = NSLocalizedString("Purchase Amount", comment: "")
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .primaryText
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let purchaseAmountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let convertedPurchaseLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let refundTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.text = NSLocalizedString("Refund Amount", comment: "")
        $0.textColor = .primaryText
        $0.numberOfLines = 0
        $0.textAlignment = .right
    }
    
    private let refundAmountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .mainTeal
        $0.textAlignment = .right
        $0.numberOfLines = 0
    }
    
    private let convertedRefundLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .mainTeal
        $0.textAlignment = .right
        $0.numberOfLines = 0
    }
    
    // 구분선
    private let dividerView = UIView().then {
        $0.backgroundColor = .currency.withAlphaComponent(0.3)
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private let conditionScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let conditionContentView = UIView().then {
        $0.backgroundColor = .subButton
        $0.layer.cornerRadius = 12
    }
    
    private let rateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.text = "💱 " +  NSLocalizedString("Applied Exchange Rate", comment: "")
        $0.textColor = .primaryText
    }
    
    private let exchangeRateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .mainTeal
    }
    
    private let rateDividerView = UIView().then {
        $0.backgroundColor = .currency.withAlphaComponent(0.3)
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private let vatLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private let vatTextLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 0
    }
    
    private let minimumLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private let minimumTextLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 0
    }
    
    private let refundMethodLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private let methodTextLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 0
    }
    
    private let refundPlaceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private let placeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 0
    }
    
    private let notesLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private let notesTextLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 0
    }
    
    private let dismissButton = UIButton(type: .system).then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainTeal
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 10
    }
    
    // MARK: - Initialize
    
    init(viewModel: SavedModalVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        view.addSubview(containerView)
        
        containerView.addSubviews(
            countryLabel, dateLabel,
            purchaseTitleLabel, purchaseAmountLabel,
            refundTitleLabel, refundAmountLabel,
            dividerView,
            convertedPurchaseLabel, convertedRefundLabel,
            conditionScrollView,
            dismissButton
        )
        
        conditionScrollView.addSubview(conditionContentView)
        
        conditionContentView.addSubviews(
            rateLabel, exchangeRateLabel,
            rateDividerView,
            vatLabel, vatTextLabel,
            minimumLabel, minimumTextLabel,
            refundMethodLabel, methodTextLabel,
            refundPlaceLabel, placeLabel,
            notesLabel, notesTextLabel
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
        
        // 구매/환급 타이틀
        purchaseTitleLabel.snp.makeConstraints {
            $0.top.equalTo(countryLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalTo(containerView.snp.centerX).offset(-4)
        }
        
        refundTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.centerX).offset(4)
            $0.top.equalTo(purchaseTitleLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        // 구매/환급 금액
        purchaseAmountLabel.snp.makeConstraints {
            $0.top.equalTo(purchaseTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(purchaseTitleLabel)
            $0.trailing.equalTo(containerView.snp.centerX).offset(-4)
            $0.firstBaseline.equalTo(refundAmountLabel.snp.firstBaseline)
        }
        
        refundAmountLabel.snp.makeConstraints {
            $0.top.equalTo(refundTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(containerView.snp.centerX).offset(4)
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
            $0.trailing.equalTo(containerView.snp.centerX).offset(-4)
        }
        
        convertedRefundLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.centerX).offset(4)
            $0.top.equalTo(dividerView.snp.bottom).offset(8)
            $0.trailing.equalTo(refundTitleLabel)
        }
        
        conditionScrollView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(convertedPurchaseLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(300)
        }
        
        conditionContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(conditionScrollView.snp.width)
        }
        
        rateLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        exchangeRateLabel.snp.makeConstraints {
            $0.top.equalTo(rateLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        rateDividerView.snp.makeConstraints {
            $0.top.equalTo(exchangeRateLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        vatLabel.snp.makeConstraints {
            $0.top.equalTo(rateDividerView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        vatTextLabel.snp.makeConstraints {
            $0.top.equalTo(vatLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        minimumLabel.snp.makeConstraints {
            $0.top.equalTo(vatTextLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        minimumTextLabel.snp.makeConstraints {
            $0.top.equalTo(minimumLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        refundMethodLabel.snp.makeConstraints {
            $0.top.equalTo(minimumTextLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        methodTextLabel.snp.makeConstraints {
            $0.top.equalTo(refundMethodLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        refundPlaceLabel.snp.makeConstraints {
            $0.top.equalTo(methodTextLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(refundPlaceLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        notesLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        notesTextLabel.snp.makeConstraints {
            $0.top.equalTo(notesLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(conditionScrollView.snp.bottom).offset(24)
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
    
    func bindViewModel() {
        viewModel.country.drive(countryLabel.rx.text).disposed(by: disposeBag)
        viewModel.date.drive(dateLabel.rx.text).disposed(by: disposeBag)
        viewModel.purchaseAmount.drive(purchaseAmountLabel.rx.text).disposed(by: disposeBag)
        viewModel.refundAmount.drive(refundAmountLabel.rx.text).disposed(by: disposeBag)
        viewModel.convertedPurchase.drive(convertedPurchaseLabel.rx.text).disposed(by: disposeBag)
        viewModel.convertedRefund.drive(convertedRefundLabel.rx.text).disposed(by: disposeBag)
        viewModel.exchangeRate.drive(exchangeRateLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.vatRateTitle.drive(vatLabel.rx.text).disposed(by: disposeBag)
        viewModel.vatRateValue.drive(vatTextLabel.rx.text).disposed(by: disposeBag)
        viewModel.minimumAmountTitle.drive(minimumLabel.rx.text).disposed(by: disposeBag)
        viewModel.minimumAmountValue.drive(minimumTextLabel.rx.text).disposed(by: disposeBag)
        viewModel.refundMethodTitle.drive(refundMethodLabel.rx.text).disposed(by: disposeBag)
        viewModel.refundMethodValue.drive(methodTextLabel.rx.text).disposed(by: disposeBag)
        viewModel.refundPlaceTitle.drive(refundPlaceLabel.rx.text).disposed(by: disposeBag)
        viewModel.refundPlaceValue.drive(placeLabel.rx.text).disposed(by: disposeBag)
        viewModel.notesTitle.drive(notesLabel.rx.text).disposed(by: disposeBag)
        viewModel.notesValue.drive(notesTextLabel.rx.text).disposed(by: disposeBag)
    }
}
