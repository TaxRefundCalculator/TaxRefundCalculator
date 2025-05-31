//
//  CalculateVC.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then

class CalculateVC: UIViewController {
    
    let viewModel = CalculateVM()
    
    // MARK: 사이즈 대응을 위한 스크롤 뷰
    let scrollView = UIScrollView()
    let scrollContentView = UIView()

    
    // MARK: 선택 통화, 환율 카드
    private let currencyRateCard = UIView().then {
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let travelCurrency = UILabel().then {
        $0.text = "이곳에 저장된 통화"
        $0.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        $0.textColor = .primaryText
    }
    private let rate = UILabel().then {
        $0.text = "1 EUR   =   1,430 KRW"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .subText
    }
    
    
    // MARK: 구매금액 입력 카드
    private let priceCard = UIView().then {
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let priceLabel = UILabel().then {
        $0.text = "구매 금액 입력"
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    private let textFieldLabel = UILabel().then {
        $0.text = "EUR    "
        $0.textColor = .subText
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    private lazy var priceTextField = UITextField().then {
        $0.placeholder = "숫자만 입력해주세요."
        $0.backgroundColor = .white
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 왼쪽 여백
        $0.leftViewMode = .always
        $0.rightView = textFieldLabel
        $0.rightViewMode = .always
    }
    
    
    // MARK: 계산 카드
    private let calculateCard = UIView().then {
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let vatLabel = UILabel().then {
        $0.text = "부가세율(VAT)"
        $0.font = UIFont.systemFont(ofSize: 19, weight: .regular)
    }
    private let percent = UILabel().then {
        $0.text = "20%"
        $0.font = UIFont.systemFont(ofSize: 19, weight: .bold)
    }
    private let separator = UIView().then {
        $0.backgroundColor = .placeholder
    }
    private let expectation = UILabel().then {
        $0.text = "예상 환급 금액"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    private let result = UILabel().then {
        $0.text = "0.00 EUR"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .mainTeal
    }
    private let summary = UILabel().then {
        $0.text = "약 0 KRW"
        $0.font = UIFont.systemFont(ofSize: 16.5, weight: .thin)
    }
    private lazy var saveBtn = UIButton().then {
        $0.backgroundColor = .mainTeal
        $0.setTitle("+ 기록 저장", for: .normal)
        $0.layer.cornerRadius = 8
    }
    private lazy var checkBtn = UIButton().then {
        $0.backgroundColor = .currency
        $0.setTitle("환급 조건 보기", for: .normal)
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(checkBtnTapped), for: .touchUpInside)
    }
    private lazy var btnStackView = UIStackView(arrangedSubviews: [saveBtn, checkBtn]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        loadTravelCurrency()
    }
    
    
    // MARK: UserDefaults에서 값 불러오기
    private func loadTravelCurrency() {
        if let savedTravelCurrency = viewModel.getTravelCurrency() {
            travelCurrency.text = savedTravelCurrency
        }
    }
    
    
    // MARK: UI 구성
    private func configureUI() {
        view.backgroundColor = .bgSecondary
        
        
        // MARK: 사이즈 대응을 위한 스크롤 뷰
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        
        // MARK: 선택된 국가 환율, 기준 환율 카드
        scrollContentView.addSubview(currencyRateCard)
        currencyRateCard.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(90)
        }
        
        currencyRateCard.addSubview(travelCurrency)
        currencyRateCard.addSubview(rate)
        
        travelCurrency.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(16)
        }
        rate.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        
        // MARK: 구매금액 입력 카드
        scrollContentView.addSubview(priceCard)
        priceCard.snp.makeConstraints {
            $0.top.equalTo(currencyRateCard.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(120)
        }
        
        priceCard.addSubview(priceLabel)
        priceCard.addSubview(priceTextField)
        
        priceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        priceTextField.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        
        // MARK: 계산 카드
        scrollContentView.addSubview(calculateCard)
        calculateCard.snp.makeConstraints {
            $0.top.equalTo(priceCard.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(240)
            $0.bottom.equalToSuperview().offset(20)
        }
        
        calculateCard.addSubview(vatLabel)
        calculateCard.addSubview(percent)
        calculateCard.addSubview(separator)
        calculateCard.addSubview(expectation)
        calculateCard.addSubview(result)
        calculateCard.addSubview(summary)
        calculateCard.addSubview(btnStackView)
        
        vatLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        percent.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        result.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        separator.snp.makeConstraints  {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(vatLabel.snp.bottom).offset(12)
            $0.height.equalTo(1)
        }
        expectation.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(result.snp.top).offset(-10)
        }
        summary.snp.makeConstraints {
            $0.top.equalTo(result.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
        }
        btnStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
    
    
    // MARK: 환급조건 보기 버튼 액션
    @objc
    private func checkBtnTapped() {
        let modal = RefundModal()
        present(modal, animated: true, completion: nil)
    }
    
}
