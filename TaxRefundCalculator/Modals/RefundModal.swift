//
//  Calculate.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 5/26/25.
//

import UIKit
import SnapKit
import Then


class RefundModal: UIViewController {
    
    // 뷰모델 선언
    let viewModel = CalculateVM()
    
    // MARK: - 모달 형태
    private let containerView = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    
    // MARK: - 스크롤뷰
    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    
    
    // MARK: - UI 요소들
    // 닫기 버튼
    private let closeBtn = UIButton().then {
        $0.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
        $0.backgroundColor = .mainTeal
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
    }
    // 국기, 국가명
    private let flagLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 50)
    }
    private let countryLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 35)
    }
    // 부가세
    private let vatLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.numberOfLines = 0
    }
    private let vatValueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    // 최소구매금액
    private let minimumLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.numberOfLines = 0
    }
    private let minimumValueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    // 환급방법
    private let refundMethodLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.numberOfLines = 0
    }
    private let refundMethodValueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    // 환급장소
    private let refundPlaceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.numberOfLines = 0
    }
    private let refundPlaceValueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    // 비고
    private let noteLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.numberOfLines = 0
    }
    private let noteValueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    
    
    // MARK: - 각 Label에 환급 조건 출력
    // userDefaults에 저장되어있는 국기 대조 후 출력
    private func loadRefundPolicy() {
        guard let (flag, policy) = viewModel.getRefundPolicyByCurrency() else {
            alert(
                title: NSLocalizedString("Error", comment: ""),
                message: NSLocalizedString("Error", comment: "")
            )
            print("환급 정책을 찾을 수 없습니다.")
            return
        }
        // 국기, 국가명
        flagLabel.text = flag
        countryLabel.text = NSLocalizedString(policy.country, comment: "")
        // 부가세율
        vatLabel.text = "💰 \(NSLocalizedString("VAT Rate", comment: ""))"
        vatValueLabel.text = "\(policy.vatRate)%"
        // 최소 구매금액
        minimumLabel.text = "💵 \(NSLocalizedString("Minimum Purchase Amount", comment: ""))"
        minimumValueLabel.text = "\(Int(policy.minimumAmount)) \(policy.currencyCode)"
        // 환급 방법
        refundMethodLabel.text = "🔁 \(NSLocalizedString("Refund Method", comment: ""))"
        refundMethodValueLabel.text = NSLocalizedString(policy.refundMethod, comment: "")
        // 환급 장소
        refundPlaceLabel.text = "📍 \(NSLocalizedString("Refund Location", comment: ""))"
        refundPlaceValueLabel.text = NSLocalizedString(policy.refundPlace, comment: "")
        // 비고
        noteLabel.text = "📌 \(NSLocalizedString("Notes", comment: ""))"
        noteValueLabel.text = NSLocalizedString(policy.notes, comment: "")
    }
    
    
    // MARK: - 초기화
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.frame = CGRect(x: 40, y: 200, width: UIScreen.main.bounds.width - 80, height: 300)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        configureUI()
        loadRefundPolicy()
    }
    
    
    // MARK: - AutoLayout 정의
    private func configureUI() {
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.85)
            $0.height.greaterThanOrEqualTo(450) // 최소높이 보장
        }
        // 닫기버튼
        containerView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(48)
        }
        // 스크롤뷰
        containerView.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(closeBtn.snp.top).offset(-16)
        }
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        // 깃발, 국가명
        scrollContentView.addSubview(flagLabel)
        flagLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        scrollContentView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints {
            $0.top.equalTo(flagLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        // 부가세
        scrollContentView.addSubview(vatLabel)
        vatLabel.snp.remakeConstraints {
            $0.top.equalTo(countryLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        scrollContentView.addSubview(vatValueLabel)
        vatValueLabel.snp.remakeConstraints {
            $0.top.equalTo(vatLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        // 최소 주문 금액
        scrollContentView.addSubview(minimumLabel)
        minimumLabel.snp.remakeConstraints {
            $0.top.equalTo(vatValueLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        scrollContentView.addSubview(minimumValueLabel)
        minimumValueLabel.snp.remakeConstraints {
            $0.top.equalTo(minimumLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        // 환급 방법
        scrollContentView.addSubview(refundMethodLabel)
        refundMethodLabel.snp.remakeConstraints {
            $0.top.equalTo(minimumValueLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        scrollContentView.addSubview(refundMethodValueLabel)
        refundMethodValueLabel.snp.remakeConstraints {
            $0.top.equalTo(refundMethodLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        // 환급장소
        scrollContentView.addSubview(refundPlaceLabel)
        refundPlaceLabel.snp.remakeConstraints {
            $0.top.equalTo(refundMethodValueLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        scrollContentView.addSubview(refundPlaceValueLabel)
        refundPlaceValueLabel.snp.remakeConstraints {
            $0.top.equalTo(refundPlaceLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        // 비고
        scrollContentView.addSubview(noteLabel)
        noteLabel.snp.remakeConstraints {
            $0.top.equalTo(refundPlaceValueLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        scrollContentView.addSubview(noteValueLabel)
        noteValueLabel.snp.remakeConstraints {
            $0.top.equalTo(noteLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
        
    // MARK: - 닫기 버튼 액션
    @objc
    private func closeBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
