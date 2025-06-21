//
//  CalculateVC.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then
import Combine

class CalculateVC: UIViewController {
    
    // MARK: 뷰모델
    private let viewModel = CalculateVM()
    
    // MARK: 의존성 주입
    private let settingVM = SettingVM.shared
    private var cancellables = Set<AnyCancellable>() // Combine 구독관리

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
    private let travelCountry = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        $0.textColor = .primaryText
    }
    private let exchangeRate = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .subText
    }
    private var currency1Num = 1
    private var currency1 = "화폐1"
    private var currency2Num = 999
    private var currency2 = "화폐2"
    
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
        $0.font = UIFont.systemFont(ofSize: 19, weight: .regular)
    }
    private let textFieldLabel = UILabel().then {
        $0.textColor = .subText
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    private lazy var priceTextField = UITextField().then {
        $0.placeholder = "숫자만 입력해주세요."
        $0.backgroundColor = .subButton
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 왼쪽 여백
        $0.leftViewMode = .always
        $0.rightView = textFieldLabel
        $0.rightViewMode = .always
        $0.keyboardType = .decimalPad
    }
    private let calculateBtn = UIButton().then {
        $0.backgroundColor = .mainTeal
        $0.setTitle("계산하기", for: .normal)
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(calculateBtnTapped), for: .touchUpInside)
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
  
    private let boughtPrice = UILabel().then {
        $0.text = "구매금액"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    private let priceNum = UILabel().then {
        $0.text = "0"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .mainTeal
    }
    private let priceCurrency = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .mainTeal
    }
    private let conversionBoughtPrice = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16.5, weight: .regular)
    }
    private lazy var priceStackView = UIStackView(arrangedSubviews: [priceNum, priceCurrency]).then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fill
    }
    
    private let separator2 = UIView().then {
        $0.backgroundColor = .placeholder
    }
    
    private let expectation = UILabel().then {
        $0.text = "예상 환급 금액"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    private let refundNum = UILabel().then {
        $0.text = "0"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .mainTeal
    }
    private let resultCurrency = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .mainTeal
    }
    private lazy var resultStackView = UIStackView(arrangedSubviews: [refundNum, resultCurrency]).then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fill
    }
    private let conversionRefuncPrice = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16.5, weight: .regular)
    }
    private lazy var saveBtn = UIButton().then {
        $0.backgroundColor = .mainTeal
        $0.setTitle("+ 기록 저장", for: .normal)
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(saveBtnTapped), for: .touchUpInside)
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
        updateFromSetting()
        loadFromUserdefaults()
        keyboardDown()
    }
    
    // MARK: Combine으로 기준 화폐, 여행화폐 최신화
    private func updateFromSetting() {
        // 기준 화폐 값 구독 (SettingVM의 baseCurrency가 바뀌면 이 코드가 실행됨)
        settingVM.$baseCurrency
            .sink { [weak self] value in
                guard !value.isEmpty else { return }
                // 기준 화폐 라벨 등 UI 업데이트
                let code = value.suffix(3)
                self?.currency2 = "\(code)"
                self?.conversionBoughtPrice.text = "약 0 \(code)"
                self?.conversionRefuncPrice.text = "약 0 \(code)"
                self?.updateExchangeRateText()
            }
            .store(in: &cancellables)
        
        // 여행 화폐 값 구독
        settingVM.$travelCountry
            .sink { [weak self] value in
                guard !value.isEmpty else { return }
                // 여행 화폐 관련 Label/필드 모두 업데이트
                self?.travelCountry.text = value           // 전체 (예: "🇯🇵 일본 - JPY")
                let code = value.suffix(3)
                self?.currency1 = " \(code)"           // 환율표시 (예: " JPY")
                self?.textFieldLabel.text = "\(code)    "   // 텍스트필드 우측 표시
                self?.priceCurrency.text = " \(code)"      // 구매금액 통화 표시
                self?.resultCurrency.text = " \(code)"      // 예상 환급금액 통화 표시
                self?.updateExchangeRateText()
            }
            .store(in: &cancellables) // 구독관리로 메모리관리
    }
    
    private func updateExchangeRateText() {
        exchangeRate.text = "\(currency1Num)\(currency1) = \(currency2Num)\(currency2)"
    }
    
    
    // MARK: UserDefaults에서 값 불러오기
    private func loadFromUserdefaults() {
        // 여행국가화폐 불러오기
        if let savedTravelCountry = viewModel.getTravelCountry3() {
            travelCountry.text = savedTravelCountry.full
            priceCurrency.text = " \(savedTravelCountry.code)"
            currency1 = " \(savedTravelCountry.code)"
            textFieldLabel.text = "\(savedTravelCountry.code)    "
            resultCurrency.text = " \(savedTravelCountry.code)"
        }
        
        // 기준화폐 가져오기
        if let savedBaseCurrency = viewModel.getBaseCurrency3() {
            currency2 = " \(savedBaseCurrency)"
            conversionBoughtPrice.text = "약 0 \(savedBaseCurrency)"
            conversionRefuncPrice.text = "약 0 \(savedBaseCurrency)"
        }
        
        // 부가세율 가져오기
        if let vatText = viewModel.getVatRate() {
            percent.text = vatText
        }
        
        exchangeRate.text = "\(viewModel.realTimeTravelCurrency)\(currency1) = \(viewModel.realTimeBaseCurrency)\(currency2)"
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
        
        currencyRateCard.addSubview(travelCountry)
        currencyRateCard.addSubview(exchangeRate)
        
        travelCountry.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(16)
        }
        exchangeRate.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        
        // MARK: 구매금액 입력 카드
        scrollContentView.addSubview(priceCard)
        priceCard.snp.makeConstraints {
            $0.top.equalTo(currencyRateCard.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(180)
        }
        
        priceCard.addSubview(priceLabel)
        priceCard.addSubview(priceTextField)
        priceCard.addSubview(calculateBtn)
        
        priceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            
        }
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        calculateBtn.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        
        // MARK: 계산 카드
        scrollContentView.addSubview(calculateCard)
        calculateCard.snp.makeConstraints {
            $0.top.equalTo(priceCard.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(360)
            $0.bottom.equalToSuperview().offset(20)
        }
        
        calculateCard.addSubview(vatLabel)
        calculateCard.addSubview(percent)
        calculateCard.addSubview(separator)
        calculateCard.addSubview(separator2)
        calculateCard.addSubview(boughtPrice)
        calculateCard.addSubview(priceStackView)
        calculateCard.addSubview(conversionBoughtPrice)
        calculateCard.addSubview(expectation)
        calculateCard.addSubview(resultStackView)
        calculateCard.addSubview(conversionRefuncPrice)
        calculateCard.addSubview(btnStackView)
        
        vatLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        percent.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        separator.snp.makeConstraints  {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(vatLabel.snp.bottom).offset(12)
            $0.height.equalTo(2)
        }
        boughtPrice.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(separator.snp.bottom).offset(15)
        }
        priceStackView.snp.makeConstraints {
            $0.top.equalTo(boughtPrice.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        conversionBoughtPrice.snp.makeConstraints {
            $0.top.equalTo(priceStackView.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
        }
        separator2.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(conversionBoughtPrice.snp.bottom).offset(15)
            $0.height.equalTo(1)
        }
        expectation.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(separator2.snp.bottom).offset(15)
        }
        resultStackView.snp.makeConstraints {
            $0.top.equalTo(expectation.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        conversionRefuncPrice.snp.makeConstraints {
            $0.top.equalTo(resultStackView.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
        }
        btnStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
    
    // MARK: 저장하기 버튼 액션
    @objc
    private func saveBtnTapped() {
        print("saveBtnTapped")

        guard let country = travelCountry.text,
              let exchangeRate = exchangeRate.text,
              let priceText = priceTextField.text,
              let refundText = refundNum.text,
              let convertedText = conversionRefuncPrice.text,
              let price = Double(priceText),
              let refund = Double(refundText.filter { $0.isNumber || $0 == "." }),
              let converted = Double(convertedText.filter { $0.isNumber || $0 == "." }) else {
            print("❌ 필수 데이터 누락 또는 변환 실패")
            return
        }

        let card = SavedCard(
            country: country,
            exchangeRate: exchangeRate,
            date: "123",
            price: price,
            refundPrice: refund,
            convertedRefundPrice: converted
        )

        viewModel.saveCard(card)
        print("✅ 저장 성공: \(card)")
        
        // 디버깅용
        let savedGroups = viewModel.loadGroupedCards()
        for (key, cards) in savedGroups {
            print("📦 저장된 키: \(key)")
            for card in cards {
                print("🔹 \(card)")
            }
        }
    }
    
    // MARK: 환급조건 보기 버튼 액션
    @objc
    private func checkBtnTapped() {
        let modal = RefundModal()
        present(modal, animated: true, completion: nil)
    }
    
    
    // MARK: 계산하기 버튼 액션 (현재 진입 테스트용 버튼)
    @objc
    private func calculateBtnTapped() {
        
        
        print("exchangeUnit(UserDefaults):", UserDefaults.standard.integer(forKey: "exchangeUnit"))
        print("exchangeValue(UserDefaults):", UserDefaults.standard.string(forKey: "exchangeValue") ?? "nil")
        // 구매금액 입력 필드 예외처리
        guard let priceText = priceTextField.text else { return }
        let isValid = viewModel.isValidFloatingPoint(priceText)
        
        if !isValid {
            errorAlert1()
            return
        }
        
        if priceText.isEmpty {
            errorAlert2()
            return
        }
        
        // MARK: 계산 로직
        // 구매 금액
        priceNum.text = priceText
        let currencyCode = viewModel.getBaseCurrency3() ?? ""
        
        // 구매금액 기준통화로 변환
        if let result = viewModel.conversionPrice(priceText: priceText) {
            conversionBoughtPrice.text = "약 \(String(format: "%.2f", result)) \(currencyCode)"
        } else {
            conversionBoughtPrice.text = "입력 오류"
        }
        
        // 환급금액(현지화폐) 계산
        if let refund = viewModel.calculateVatRefund(priceText: priceNum.text ?? "") {
            refundNum.text = String(format: "%.2f", refund)
            // 환급금액을 환율로 변환해서 conversionRefuncPrice에 표시
            if let refundInBase = viewModel.convertRefundToBaseCurrency(refund: refund) {
                conversionRefuncPrice.text = "약 \(String(format: "%.2f", refundInBase)) \(currencyCode)"
            } else {
                conversionRefuncPrice.text = "환산 오류"
            }
        } else {
            refundNum.text = "계산 오류"
            conversionRefuncPrice.text = ""
        }

    }
    
    
    // MARK: 키보드 내리기
    private func keyboardDown() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDownAction))
        tapGesture.cancelsTouchesInView = false // 다른 터치 이벤트도 전달되도록 설정
        view.addGestureRecognizer(tapGesture)
    }
    @objc
    private func keyboardDownAction() {
        view.endEditing(true)
    }
    
}

// MARK: 가격 입력 필드 예외처리
extension CalculateVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let current = textField.text ?? ""
        let nsCurrent = current as NSString
        let newValue = nsCurrent.replacingCharacters(in: range, with: string)

        let isValid = viewModel.isValidFloatingPoint(newValue)

        // 부적합 입력시 얼럿 표시
        if !isValid && !string.isEmpty {
            errorAlert1()
        }
        // 공백 입력 시 얼럿 표시
        if string.isEmpty {
            errorAlert2()
        }
        return isValid
    }
    
    // 오입력 얼럿
    private func errorAlert1() {
        let alert = UIAlertController(title: "입력 오류", message: "숫자와 소수점만, 그리고 소수점은 한 번만 입력할 수 있습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    // 공백 입력 얼럿
    private func errorAlert2() {
        let alert = UIAlertController(title: "입력 오류", message: "공백은 입력할 수 없습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
