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
    
    
    // MARK: 스크롤뷰
    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    
    
    private let titleLabel = UILabel().then {
        $0.text = "환급 조건"
        $0.textAlignment = .left
        $0.textColor = .primaryText
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    }
    
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
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    
    private func loadRefundPolicy() {
        guard let (flag, policy) = viewModel.getRefundPolicyByCurrency() else {
            print("환급 정책을 찾을 수 없습니다.")
            return
        }
        flagLabel.text = flag
        countryLabel.text = policy.country
        refundInfoLabel.text = """
        💰 VAT율 :  \(policy.vatRate)%\n\n
        💵 최소 구매금액 :  \(Int(policy.minimumAmount)) \(policy.currencyCode)\n\n
        🔁 환급 방법 :  \(policy.refundMethod)\n\n
        📍 환급 장소 :  \(policy.refundPlace)\n\n
        📌 비고 :  \(policy.notes)
        """
    }
    
    
    override func viewDidLoad() {
        modalPresentationStyle = .fullScreen
        super.viewDidLoad()
        
        configureUI()
        loadRefundPolicy()
    }
    
    
    // MARK: AutoLayout 정의
    private func configureUI() {
        view.backgroundColor = .bgSecondary // 배경컬러
        
        // 제목
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        // 닫기 버튼
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(55)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(closeBtn.snp.top)
        }
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        scrollContentView.addSubview(flagLabel)
        flagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
        
        scrollContentView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints {
            $0.top.equalTo(flagLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        scrollContentView.addSubview(refundInfoLabel)
        refundInfoLabel.numberOfLines = 0
        refundInfoLabel.snp.makeConstraints {
            $0.top.equalTo(countryLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
        
    
    @objc
    private func closeBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
