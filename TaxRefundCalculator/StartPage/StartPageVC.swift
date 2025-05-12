//
//  StartPageVC.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then

class StartPageVC: UIViewController, UITextFieldDelegate, CountryModalDelegate {
    
    // MARK: 상단 제목 두개
    private let titleLabel = UILabel().then {
        $0.text = "택스리펀 환급금 예상 계산기"
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 25)
    }
    private let subLabel = UILabel().then {
        $0.text = "해외 쇼핑 시 세금 환급 금액을 미리 계산해보세요."
        $0.textAlignment = .center
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    
    
    // MARK: 기준 통화 선택, 여행국가 선택 카드
    private let currencyCard = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let baseCurrency = UILabel().then {
        $0.text = "기준 통화 선택"
        $0.textAlignment = .left
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    private let travelCurrency = UILabel().then {
        $0.text = "여행국가 선택"
        $0.textAlignment = .left
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    private let textField = UITextField().then {
        $0.placeholder = "기준화폐를 선택하세요."
        $0.backgroundColor = .white
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
        $0.tag = 0
    }
    private let textField2 = UITextField().then {
        $0.placeholder = "여행국가를 선택하세요."
        $0.backgroundColor = .white
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
        $0.tag = 1
    }
    
    
    // MARK: 온오프라인 모드 카드
    private let networkCard = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let networkLabel = UILabel().then {
        $0.text = "인터넷 연결"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .ultraLight)
    }
    private let networkTextField = UITextField().then {
        $0.text = "오프라인 모드"
        $0.textColor = .downRed
        $0.backgroundColor = .white
        $0.borderStyle = .none
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        $0.leftViewMode = .always
        $0.isUserInteractionEnabled = false // 커서 생성 방지
    }
    private let networkSwitch = UISwitch().then {
        $0.isOn = false
        $0.onTintColor = .mainTeal
        $0.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    
    // MARK: 환율 정보 카드
    private let exchangeRateCard = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let exchangeRateLabel = UILabel().then {
        $0.text = "환율 정보"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .ultraLight)
    }
    private let exchangeRateTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.borderStyle = .none
        $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        $0.rightViewMode = .always
    }
    
    
    // MARK: 환급 조건 카드
    private let conditionCard = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    // MARK: 시작버튼
    private let startButton = UIButton().then {
        $0.setTitle("시작하기 →", for: .normal)
        $0.backgroundColor = .mainTeal
        $0.layer.cornerRadius = 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        textField2.delegate = self
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .bgSecondary
        
        view.addSubview(titleLabel) // "택스리펀 환급금 예상 계산기"
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            //$0.top.equalToSuperview().inset(70)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        view.addSubview(subLabel) // "해외 쇼핑 시 세금 환급 금액을 미리 계산해보세요."
        subLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        
        // MARK: 기준 통화 선택, 여행국가 선택 카드
        view.addSubview(currencyCard)
        currencyCard.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(230)
            // $0.height.equalTo(view.snp.height).multipliedBy(0.25) // 화면 높이의 약 1/3
        }
        
        currencyCard.addSubview(baseCurrency)
        currencyCard.addSubview(textField)
        currencyCard.addSubview(travelCurrency)
        currencyCard.addSubview(textField2)
        
        baseCurrency.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(baseCurrency.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(55)
        }
        travelCurrency.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        textField2.snp.makeConstraints {
            $0.top.equalTo(travelCurrency.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(55)
        }
        
        
        // MARK: 온오프라인 모드 카드
        view.addSubview(networkCard)
        networkCard.snp.makeConstraints {
            $0.top.equalTo(currencyCard.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(65)
        }
        
        networkCard.addSubview(networkLabel)
        networkCard.addSubview(networkTextField)
        networkCard.addSubview(networkSwitch)
        
        networkLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        networkTextField.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        networkSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        
        // MARK: 환율 정보 카드
        view.addSubview(exchangeRateCard)
        exchangeRateCard.snp.makeConstraints {
            $0.top.equalTo(networkCard.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(65)
        }
        
        exchangeRateCard.addSubview(exchangeRateLabel)
        exchangeRateCard.addSubview(exchangeRateTextField)
        
        exchangeRateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        exchangeRateTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
            $0.leading.equalTo(exchangeRateLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        
        // MARK: 환급 조건 카드
        view.addSubview(conditionCard)
        conditionCard.snp.makeConstraints {
            $0.top.equalTo(exchangeRateCard.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(65)
        }
        
        
        // MARK: 시작하기 버튼
        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(55)
        }

    }
    
    // MARK: 모달 관련
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let countryModal = CountryModal()
        countryModal.delegate = self
        countryModal.selectedTextFieldTag = textField.tag
        countryModal.modalPresentationStyle = .pageSheet
        
        present(countryModal, animated: true, completion: nil)
        return false
    }
    func didSelectCountry(_ country: String, forFieldTag tag: Int) {
        switch tag {
        case 0:
            textField.text = country
        case 1:
            textField2.text = country
        default:
            break
        }
    }
    
    
    // MARK: 온오프라인 토글버튼 액션
    private let viewModel = StartPageVM()

    @objc private func switchValueChanged(_ sender: UISwitch) {
        let result = viewModel.getNetworkStatus(isOnline: sender.isOn)
        networkTextField.text = result.text
        networkTextField.textColor = result.color
    }
    
    
}
