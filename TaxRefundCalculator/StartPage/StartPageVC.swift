//
//  StartPageVC.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class StartPageVC: UIViewController, UITextFieldDelegate, CountryModalDelegate, LanguageModalDelegate {
    
    private let viewModel : StartPageVM
    private let disposeBag = DisposeBag()
    
    init(viewModel: StartPageVM = StartPageVM(firebaseService: FirebaseExchangeService())) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 상단 제목 두개
    private let titleLabel = UILabel().then {
        $0.text = "택스리펀 환급금 예상 계산기"
        $0.textAlignment = .center
        $0.textColor = .primaryText
        $0.font = UIFont.boldSystemFont(ofSize: 27)
    }
    private let subLabel = UILabel().then {
        $0.text = "해외 쇼핑 시 세금 환급 금액을 미리 계산해보세요."
        $0.textAlignment = .center
        $0.textColor = .subText
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    
    // MARK: 사이즈 대응을 위한 스크롤 뷰
    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    
    
    // MARK: 언어 선택 카드
    private let languageCard = UIView().then {
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let languageLabel = UILabel().then {
        $0.text = "언어 선택"
        $0.textAlignment = .left
        $0.textColor = .primaryText
        $0.font = UIFont.systemFont(ofSize: 17)
    }
    private let languageField = UITextField().then {
        $0.placeholder = "언어를 선택하세요."
        $0.backgroundColor = .subButton
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
        $0.tag = 0
    }
    
    
    // MARK: 기준 통화 선택, 여행국가 선택 카드
    private let currencyCard = UIView().then {
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }

    private let baseCurrency = UILabel().then {
        $0.text = "기준 통화 선택"
        $0.textAlignment = .left
        $0.textColor = .primaryText
        $0.font = UIFont.systemFont(ofSize: 17)
    }
    let baseCurrencyField = UITextField().then {
        $0.placeholder = "기준화폐를 선택하세요."
        $0.backgroundColor = .subButton
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
        $0.tag = 1
    }
    private let travelCountry = UILabel().then {
        $0.text = "여행국가 선택"
        $0.textAlignment = .left
        $0.textColor = .primaryText
        $0.font = UIFont.systemFont(ofSize: 17)
    }
    private let travelCountryField = UITextField().then {
        $0.placeholder = "여행국가를 선택하세요."
        $0.backgroundColor = .subButton
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
        $0.tag = 2
    }
    
    
    // MARK: 환율 정보 카드
    private let exchangeRateCard = UIView().then {
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let exchangeRateTitle = UILabel().then {
        $0.text = "환율 정보"
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .primaryText
    }
    private let exchangeRate = UILabel().then {
        $0.text = "1USD = 1400KRW"
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .mainTeal
    }
    
    
    // MARK: 환급 조건 카드
    private let conditionCard = UIView().then {
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let conditionLabel = UILabel().then {
        $0.text = "환급 조건"
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .primaryText
    }
    private let refundCondition = UILabel().then {
        $0.text = "여행국가를 선택해주세요."
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .mainTeal
    }
    
    
    
    // MARK: 시작버튼
    private let startButton = UIButton().then {
        $0.setTitle("시작하기 →", for: .normal)
        $0.backgroundColor = .mainTeal
        $0.layer.cornerRadius = 15
        
        $0.addTarget(self, action: #selector(startBtnTapped), for: .touchUpInside)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageField.delegate = self
        baseCurrencyField.delegate = self
        travelCountryField.delegate = self
        
        configureUI()
        bindExchangeRate()
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
        currencyCard.addSubview(travelCountry)
        currencyCard.addSubview(travelCountryField)
        
        baseCurrency.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        baseCurrencyField.snp.makeConstraints {
            $0.top.equalTo(baseCurrency.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(55)
        }
        travelCountry.snp.makeConstraints {
            $0.top.equalTo(baseCurrencyField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        travelCountryField.snp.makeConstraints {
            $0.top.equalTo(travelCountry.snp.bottom).offset(8)
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
        
        exchangeRateCard.addSubview(exchangeRateTitle)
        exchangeRateCard.addSubview(exchangeRate)
        
        exchangeRateTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        exchangeRate.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
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
        
        conditionCard.addSubview(conditionLabel)
        conditionCard.addSubview(refundCondition)
        
        conditionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        refundCondition.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
            $0.trailing.equalToSuperview().inset(20)
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
    }
    
    // 화폐 선택
    func didSelectCountry(_ country: String, forFieldTag tag: Int) {
        switch tag {
        case 1:
            baseCurrencyField.text = country
            baseCurrencyField.sendActions(for: .editingChanged) // 선택이벤트 전달
            viewModel.saveBaseCurrency(country) // userDefaults에 저장
        case 2:
            travelCountryField.text = country
            travelCountryField.sendActions(for: .editingChanged) // 선택이벤트 전달
            viewModel.saveTravelCountry(country) // userDefaults에 저장
            refundCondition.text = viewModel.refundConditionText(for: country)
        default:
            break
        }
    }
    
    
    // MARK: 시작하기버튼 액션
    @objc
    private func startBtnTapped() {
        let isValid = viewModel.isInputValid(
            language: languageField.text,
            baseCurrency: baseCurrencyField.text,
            travelCountry: travelCountryField.text
        )

        if isValid {
            let tabBar = TabBarController()
            tabBar.modalPresentationStyle = .fullScreen
            present(tabBar, animated: true, completion: nil)
            viewModel.saveDoneFIrstStep(true)
        } else {
            let alert = UIAlertController(title: "입력 확인", message: "모든 항목을 선택해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: 환율정보 바인딩 (Rx) - Na
    private func bindExchangeRate() {
        Observable
            .combineLatest(baseCurrencyField.rx.text.orEmpty, travelCountryField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] base, travel in
                guard let self = self else { return }
                guard !base.isEmpty, !travel.isEmpty else {
                    // 환율정보 텍스트에 emit
                    self.viewModel.exchangeRateText.accept("화폐, 국가 선택이 필요합니다.")
                    return
                }
                // 뷰모델에 환율정보 요청
                self.viewModel.fetchExchangeText(base: base, travel: travel)
            })
            .disposed(by: disposeBag)
        
        // Relay를 UI에 바인딩
        viewModel.exchangeRateText
            .asDriver()
            .drive(exchangeRate.rx.text)
            .disposed(by: disposeBag)
    }
    
}
