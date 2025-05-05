//
//  StartPageVC.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then

class StartPageVC: UIViewController {
    
    // MARK: Labels
    private let titleLabel = UILabel().then {
        $0.text = "택스리펀 환급금 예상 계산기"
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    private let subLabel = UILabel().then {
        $0.text = "해외 쇼핑 시 세금 환급 금액을 미리 계산해보세요."
        $0.textAlignment = .center
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    // MARK: 기준 통화 선택, 여행국가 선택 카드
    private let currencyCard = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }

    private let baseCurrency = UILabel().then {
        $0.text = "기준 통화 선택"
        $0.textAlignment = .left
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    private let travelCurrency = UILabel().then {
        $0.text = "여행국가 선택"
        $0.textAlignment = .left
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    
    private let textField = UITextField().then {
        $0.placeholder = "기준화폐 선택"
        $0.backgroundColor = .white
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 1.0 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
    }
    private let textField2 = UITextField().then {
        $0.placeholder = "여행국가 선택"
        $0.backgroundColor = .white
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 1.0 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
    }
    
    // MARK: 온오프라인 모드 카드
    private let networkCard = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
        
    // MARK: 환율 정보 카드
    private let exchangeRateCard = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    // MARK: 환급 조건 카드
    private let conditionCard = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    // MARK: 시작버튼
    private let startButton = UIButton().then {
        $0.setTitle("시작하기", for: .normal)
        $0.backgroundColor = .mainTeal
        $0.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel) // "택스리펀 환급금 예상 계산기"
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.top.equalToSuperview().inset(70)
        }
        
        view.addSubview(subLabel) // "해외 쇼핑 시 세금 환급 금액을 미리 계산해보세요."
        subLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        // MARK: 기준 통화 선택, 여행국가 선택 카드
        view.addSubview(currencyCard)
        currencyCard.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(view.snp.height).multipliedBy(0.25) // 화면 높이의 약 1/3
        }
        currencyCard.addSubview(baseCurrency)
        baseCurrency.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        currencyCard.addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalTo(baseCurrency.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(40)
        }
        currencyCard.addSubview(travelCurrency)
        travelCurrency.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        currencyCard.addSubview(textField2)
        textField2.snp.makeConstraints {
            $0.top.equalTo(travelCurrency.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(40)
        }
        
        // MARK: 온오프라인 모드 카드
        view.addSubview(networkCard)
        networkCard.snp.makeConstraints {
            $0.top.equalTo(currencyCard.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(view.snp.height).multipliedBy(0.1) // 화면 높이의 약 1/3
        }
        
        // MARK: 환율 정보 카드
        view.addSubview(exchangeRateCard)
        exchangeRateCard.snp.makeConstraints {
            $0.top.equalTo(networkCard.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(view.snp.height).multipliedBy(0.1) // 화면 높이의 약 1/3
        }
        
        // MARK: 환급 조건 카드
        view.addSubview(conditionCard)
        conditionCard.snp.makeConstraints {
            $0.top.equalTo(exchangeRateCard.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(view.snp.height).multipliedBy(0.1) // 화면 높이의 약 1/3
        }

    }
}
