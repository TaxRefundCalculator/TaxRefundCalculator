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

class StartPageVC: UIViewController, UITextFieldDelegate, CountryModalDelegate {
    
    private let viewModel : StartPageVM
    private let disposeBag = DisposeBag()
    
    init(viewModel: StartPageVM = StartPageVM(firebaseService: FirebaseExchangeService())) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 상단 제목 두개
    private let titleLabel = UILabel().then {
        $0.text = NSLocalizedString("Tax Refund Calculator", comment: "")
        $0.textAlignment = .center
        $0.textColor = .primaryText
        $0.font = UIFont.boldSystemFont(ofSize: 27)
    }
    private let subLabel = UILabel().then {
        $0.text = NSLocalizedString("Calculate your tax refund amount in advance.", comment: "")
        $0.textAlignment = .center
        $0.textColor = .subText
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    
    // MARK: - 사이즈 대응을 위한 스크롤 뷰
    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    
    
    // MARK: - 기준 통화 선택, 여행국가 선택 카드
    private let currencyCard = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }

    private let baseCurrency = UILabel().then {
        $0.text = NSLocalizedString("Select Base Currency", comment: "")
        $0.textAlignment = .left
        $0.textColor = .primaryText
        $0.font = UIFont.systemFont(ofSize: 17)
    }
    let baseCurrencyField = UITextField().then {
        $0.placeholder = NSLocalizedString("Please select a base currency.", comment: "")
        $0.backgroundColor = .bgPrimary
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
        $0.tag = 0
    }
    private let travelCountry = UILabel().then {
        $0.text = NSLocalizedString("Select Travel Country", comment: "")
        $0.textAlignment = .left
        $0.textColor = .primaryText
        $0.font = UIFont.systemFont(ofSize: 17)
    }
    private let travelCountryField = UITextField().then {
        $0.placeholder = NSLocalizedString("Please select a travel country.", comment: "")
        $0.backgroundColor = .bgPrimary
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
        $0.tag = 1
    }
    
    
    // MARK: - 환율 정보 카드
    private let exchangeRateCard = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let exchangeRateTitle = UILabel().then {
        $0.text = NSLocalizedString("Exchange Rate Info", comment: "")
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .primaryText
    }
    private let exchangeRate = UILabel().then {
        $0.text = "Error"
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .mainTeal
    }
    
    
    // MARK: - 환급 조건 카드
    private let conditionCard = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let conditionLabel = UILabel().then {
        $0.text = NSLocalizedString("Refund Policy", comment: "")
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .primaryText
    }
    private let refundCondition = UILabel().then {
        $0.text = NSLocalizedString("Please select a travel country.", comment: "")
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .mainTeal
        $0.numberOfLines = 0  // 줄수 제약 x
    }
    
    
    
    // MARK: - 시작버튼
    private let startButton = UIButton().then {
        $0.setTitle(NSLocalizedString("Start →", comment: ""), for: .normal)
        $0.backgroundColor = .mainTeal
        $0.layer.cornerRadius = 15
        
        $0.addTarget(self, action: #selector(startBtnTapped), for: .touchUpInside)
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseCurrencyField.delegate = self
        travelCountryField.delegate = self
        
        configureUI()
        bindExchangeRate()
    }
    
    
    // MARK: - AutoLayout 정의
    private func configureUI() {
        view.backgroundColor = .bgPrimary
        
        // MARK: - Labels
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
        
        
        // MARK: - 시작하기 버튼
        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(55)
        }
        
        
        // MARK: - 사이즈 대응을 위한 스크롤 뷰
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
        
        
        // MARK: - 기준 통화 선택, 여행국가 선택 카드
        scrollContentView.addSubview(currencyCard)
        currencyCard.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(230)
        }
        
        currencyCard.addSubview(baseCurrency)
        currencyCard.addSubview(baseCurrencyField)
        currencyCard.addSubview(travelCountry)
        currencyCard.addSubview(travelCountryField)
        
        baseCurrency.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        baseCurrencyField.snp.makeConstraints {
            $0.top.equalTo(baseCurrency.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(55)
        }
        travelCountry.snp.makeConstraints {
            $0.top.equalTo(baseCurrencyField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        travelCountryField.snp.makeConstraints {
            $0.top.equalTo(travelCountry.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(55)
        }
        
        
        // MARK: - 환율 정보 카드
        scrollContentView.addSubview(exchangeRateCard)
        exchangeRateCard.snp.makeConstraints {
            $0.top.equalTo(currencyCard.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(80)
        }
        
        exchangeRateCard.addSubview(exchangeRateTitle)
        exchangeRateCard.addSubview(exchangeRate)
        
        exchangeRateTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        exchangeRate.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        
        // MARK: - 환급 조건 카드
        scrollContentView.addSubview(conditionCard)
        conditionCard.snp.makeConstraints {
            $0.top.equalTo(exchangeRateCard.snp.bottom).offset(15)
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        conditionCard.addSubview(conditionLabel)
        conditionCard.addSubview(refundCondition)
        
        conditionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        refundCondition.snp.makeConstraints {
            $0.top.equalTo(conditionLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16) // 리딩, 트레일링 동시
        }


    }
    
    // MARK: - 모달 관련
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 || textField.tag == 1 {
            let countryModal = CountryModal()
            countryModal.delegate = self
            countryModal.selectedTextFieldTag = textField.tag
            countryModal.currentBaseCurrency = baseCurrencyField.text
            countryModal.currentTravelCurrency = travelCountryField.text
            countryModal.modalPresentationStyle = .pageSheet
            present(countryModal, animated: true, completion: nil)
        }
        return false
    }
    
    
    // MARK: - 텍스트필드에 리턴 및 유저디폴트에 저장
    // 화폐 선택
    func didSelectCountry(_ country: String, forFieldTag tag: Int) {
        switch tag {
        case 0:
            baseCurrencyField.text = country
            baseCurrencyField.sendActions(for: .editingChanged) // 선택이벤트 전달
            viewModel.saveBaseCurrency(country) // userDefaults에 저장
        case 1:
            travelCountryField.text = country
            travelCountryField.sendActions(for: .editingChanged) // 선택이벤트 전달
            viewModel.saveTravelCountry(country) // userDefaults에 저장
            refundCondition.text = viewModel.refundConditionText(for: country)
        default:
            break
        }
    }
    
    
    // MARK: - 시작하기버튼 액션
    @objc
    private func startBtnTapped() {
        // 모두 선택되었는지 검증
        let validation = viewModel.validateInput(
            baseCurrency: baseCurrencyField.text,
            travelCountry: travelCountryField.text
        )
        
        switch validation {
        case .valid:
            if viewModel.exchangeRateText.value == NSLocalizedString("Unable to load exchange rate information", comment: "환율 정보를 불러올 수 없습니다") {
                let alert = UIAlertController(
                    title: NSLocalizedString("Network Required", comment: ""),
                    message: NSLocalizedString("Data connection is required to proceed", comment: ""),
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            let tabBar = TabBarController()
            tabBar.modalPresentationStyle = .fullScreen
            present(tabBar, animated: true, completion: nil)
            viewModel.saveDoneFIrstStep(true)
        case .empty:
            alert(
                title: NSLocalizedString("Input Confirmation", comment: ""),
                message: NSLocalizedString("Please select all items.", comment: "")
            )
        }
    }

    
    // MARK: - 환율정보 바인딩 (Rx) - Na
    private func bindExchangeRate() {
        Observable
            .combineLatest(baseCurrencyField.rx.text.orEmpty, travelCountryField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] base, travel in
                guard let self = self else { return }
                guard !base.isEmpty, !travel.isEmpty else {
                    // 환율정보 텍스트에 emit
                    self.viewModel.exchangeRateText.accept(NSLocalizedString("Please select a currency and a country.", comment: ""))
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
