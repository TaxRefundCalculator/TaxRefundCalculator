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
    
    private let containerView = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    
    // MARK: 스크롤뷰
    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    
    
    // MARK: UI 요소들
    private let closeBtn = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.backgroundColor = .mainTeal
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
    }
    private let flagLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 50)
    }
    private let countryLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 35)
    }
    private let refundInfoLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    
    // MARK: 각 Label에 환급 조건 출력
    // userDefaults에 저장되어있는 국기 대조 후 출력
    private func loadRefundPolicy() {
        guard let (flag, policy) = viewModel.getRefundPolicyByCurrency() else {
            print("환급 정책을 찾을 수 없습니다.")
            return
        }
        flagLabel.text = flag
        countryLabel.text = policy.country
        refundInfoLabel.text = """
        💰 VAT율 :  \(policy.vatRate)%\n
        💵 최소 구매금액 :  \(Int(policy.minimumAmount)) \(policy.currencyCode)\n
        🔁 환급 방법 :  \(policy.refundMethod)\n
        📍 환급 장소 :  \(policy.refundPlace)\n
        📌 비고 :  \(policy.notes)
        """
    }
    
    
    // MARK: 초기화
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
    
    
    // MARK: AutoLayout 정의
    private func configureUI() {
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.85)
            $0.height.greaterThanOrEqualTo(450) // 최소높이 보장
        }
        
        containerView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(55)
        }
        
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
        
        scrollContentView.addSubview(refundInfoLabel)
        refundInfoLabel.numberOfLines = 0
        refundInfoLabel.snp.remakeConstraints {
            $0.top.equalTo(countryLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
        
    // MARK: 닫기 버튼 액션
    @objc
    private func closeBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
