//
//  StartPageVC.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then

class StartPageVC: UIViewController, UITextFieldDelegate, CountryModalDelegate, LanguageModalDelegate {
    
    private let viewModel = StartPageVM()
    
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
    
    
    // MARK: 사이즈 대응을 위한 스크롤 뷰
    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    
    
    // MARK: 언어 선택 카드
    private let languageCard = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let languageLabel = UILabel().then {
        $0.text = "언어 선택"
        $0.textAlignment = .left
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    private let languageField = UITextField().then {
        $0.placeholder = "언어를 선택하세요."
        $0.backgroundColor = .white
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
        $0.tag = 0
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
    let baseCurrencyField = UITextField().then {
        $0.placeholder = "기준화폐를 선택하세요."
        $0.backgroundColor = .white
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
        $0.tag = 1
    }
    private let travelCurrency = UILabel().then {
        $0.text = "여행국가 선택"
        $0.textAlignment = .left
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    private let travelCurrencytField = UITextField().then {
        $0.placeholder = "여행국가를 선택하세요."
        $0.backgroundColor = .white
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
        $0.tag = 2
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
        
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageField.delegate = self
        baseCurrencyField.delegate = self
        travelCurrencytField.delegate = self
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .bgSecondary
        
        // MARK: Labels
        view.addSubview(titleLabel) // "택스리펀 환급금 예상 계산기"
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        view.addSubview(subLabel) // "해외 쇼핑 시 세금 환급 금액을 미리 계산해보세요."
        subLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        
        // MARK: 시작하기 버튼
        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(55)
        }
        
        
        // MARK: 사이즈 대응을 위한 스크롤 뷰
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(startButton.snp.top)
        }

        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        
        // MARK: 언어 선택 카드
        scrollContentView.addSubview(languageCard)
        languageCard.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(130)
        }
        
        languageCard.addSubview(languageLabel)
        languageCard.addSubview(languageField)
        
        languageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        languageField.snp.makeConstraints {
            $0.top.equalTo(languageLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(55)
        }
        
        
        // MARK: 기준 통화 선택, 여행국가 선택 카드
        scrollContentView.addSubview(currencyCard)
        currencyCard.snp.makeConstraints {
            $0.top.equalTo(languageCard.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(230)
            // $0.height.equalTo(view.snp.height).multipliedBy(0.25) // 화면 높이의 약 1/3
        }
        
        currencyCard.addSubview(baseCurrency)
        currencyCard.addSubview(baseCurrencyField)
        currencyCard.addSubview(travelCurrency)
        currencyCard.addSubview(travelCurrencytField)
        
        baseCurrency.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        baseCurrencyField.snp.makeConstraints {
            $0.top.equalTo(baseCurrency.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(55)
        }
        travelCurrency.snp.makeConstraints {
            $0.top.equalTo(baseCurrencyField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        travelCurrencytField.snp.makeConstraints {
            $0.top.equalTo(travelCurrency.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(55)
        }
        
        
        // MARK: 환율 정보 카드
        scrollContentView.addSubview(exchangeRateCard)
        exchangeRateCard.snp.makeConstraints {
            $0.top.equalTo(currencyCard.snp.bottom).offset(15)
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
        scrollContentView.addSubview(conditionCard)
        conditionCard.snp.makeConstraints {
            $0.top.equalTo(exchangeRateCard.snp.bottom).offset(15)
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(65)
            
        }

    }
    
    // MARK: 모달 관련
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            let languageModal = LanguageModal()
            languageModal.delegate = self
            languageModal.modalPresentationStyle = .pageSheet
            present(languageModal, animated: true, completion: nil)
        } else {
            let countryModal = CountryModal()
            countryModal.delegate = self
            countryModal.selectedTextFieldTag = textField.tag
            countryModal.modalPresentationStyle = .pageSheet
            present(countryModal, animated: true, completion: nil)
        }
        return false
    }
    
    
    // MARK: 텍스트필드에 리턴 및 유저디폴트에 저장
    // 언어 선택
    func didSelectLanguage(_ language: String) {
        languageField.text = language
        viewModel.saveSelectedLanguage(language) // userDefaults에 저장
        print("유저디폴트에 \(language)가 선택된 언어로 저장됨")
    }
    
    // 화폐 선택
    func didSelectCountry(_ country: String, forFieldTag tag: Int) {
        switch tag {
        case 1:
            baseCurrencyField.text = country
            viewModel.saveBaseCurrency(country) // userDefaults에 저장
        case 2:
            travelCurrencytField.text = country
            viewModel.saveTravelCurrency(country) // userDefaults에 저장
            // 선택된 country에서 환급 정책 출력
            let policy = viewModel.getRefundPolicy(for: country) // userDefaults에 저장
            print("📌 환급 정책: \(policy)")
        default:
            break
        }
    }
    
    
    // MARK: 시작하기버튼 액션
    @objc
    private func startButtonTapped() {
        let tabBar = TabBarController()
        self.navigationController?.pushViewController(tabBar, animated: true)

    }
    
    
}

// **TODO**
// 키보드 내리기 등 설정하기
// 뷰, 뷰컨 나누기

