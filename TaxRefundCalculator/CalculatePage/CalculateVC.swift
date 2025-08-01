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
    
    // MARK: - 뷰모델
    private let viewModel = CalculateVM()
    
    // MARK: - 의존성 주입
    private let settingVM = SettingVM.shared
    private var cancellables = Set<AnyCancellable>() // Combine 구독관리

    // MARK: - 사이즈 대응을 위한 스크롤 뷰
    let scrollView = UIScrollView()
    let scrollContentView = UIView()

    
    // MARK: - 선택 통화, 환율 카드
    private let currencyRateCard = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 16
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
    
    // MARK: - 구매금액 입력 카드
    private let priceCard = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let priceLabel = UILabel().then {
        $0.text = NSLocalizedString("Enter purchase amount", comment: "")
        $0.font = UIFont.systemFont(ofSize: 19, weight: .regular)
    }
    private let textFieldLabel = UILabel().then {
        $0.textColor = .subText
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    private lazy var priceTextField = UITextField().then {
        $0.placeholder = NSLocalizedString("Please enter numbers only.", comment: "")
        $0.backgroundColor = .subButton
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 0.7 // 테두리 두께 설정
        $0.layer.cornerRadius = 12 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 왼쪽 여백
        $0.leftViewMode = .always
        $0.rightView = textFieldLabel
        $0.rightViewMode = .always
        $0.keyboardType = .decimalPad
    }
    private let calculateBtn = UIButton().then {
        $0.backgroundColor = .mainTeal
        $0.setTitle(NSLocalizedString("Calculate", comment: ""), for: .normal)
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(calculateBtnTapped), for: .touchUpInside)
    }
    
    // MARK: - 계산 카드
    private let calculateCard = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let vatLabel = UILabel().then {
        $0.text = NSLocalizedString("VAT Rate", comment: "")
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
        $0.text = NSLocalizedString("Purchase Amount", comment: "")
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
        $0.text = NSLocalizedString("Estimated Refund Amount", comment: "")
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    private let refundNum = UILabel().then {
        $0.text = "0"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .mainTeal
    }
    private let refundCurrency = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .mainTeal
    }
    private let conversionRefundPrice = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16.5, weight: .regular)
    }
    private lazy var resultStackView = UIStackView(arrangedSubviews: [refundNum, refundCurrency]).then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fill
    }
    private lazy var saveBtn = UIButton().then {
        $0.backgroundColor = .mainTeal
        $0.setTitle(NSLocalizedString("Save Record", comment: ""), for: .normal)
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(saveBtnTapped), for: .touchUpInside)
    }
    private lazy var checkBtn = UIButton().then {
        $0.backgroundColor = .grayBtn
        $0.setTitle(NSLocalizedString("View Refund Policy", comment: ""), for: .normal)
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(checkBtnTapped), for: .touchUpInside)
    }
    private lazy var btnStackView = UIStackView(arrangedSubviews: [saveBtn, checkBtn]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        updateFromSetting()
        loadFromUserdefaults()
        keyboardDown()
    }
    
    // MARK: - Combine으로 기준 화폐, 여행화폐 최신화
    private func updateFromSetting() {
        // 기준 화폐 값 구독 (SettingVM의 baseCurrency가 바뀌면 이 코드가 실행됨)
        settingVM.$baseCurrency
            .sink { [weak self] value in
                guard !value.isEmpty else { return }
                // 기준 화폐 라벨 등 UI 업데이트
                let code = value.suffix(3)
                self?.currency2 = "\(code)"
                self?.conversionBoughtPrice.text = "\(NSLocalizedString("Approx ", comment: "")) 0 \(code)"
                self?.conversionRefundPrice.text = "\(NSLocalizedString("Approx ", comment: "")) 0 \(code)"
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
                self?.refundCurrency.text = " \(code)"      // 예상 환급금액 통화 표시
            }
            .store(in: &cancellables) // 구독관리로 메모리관리
        
        // 환율정보 구독
        settingVM.$exchangeValue
                    .sink { [weak self] value in
                        // 환율 UI를 최신값으로 갱신
                        self?.updateExchangeRateText()
                    }
                    .store(in: &cancellables)
        
        // 화폐단위 구독
        settingVM.$travelCurrencyUnit
                    .sink { [weak self] _ in
                        // 단위 UI도 필요하다면 갱신
                        self?.updateExchangeRateText()
                    }
                    .store(in: &cancellables)
    }
    
    // 환율 텍스트 갱신
    private func updateExchangeRateText() {
        exchangeRate.text = "\(viewModel.getTravelCurrencyUnit()) \(currency1) = \(viewModel.getExchangeValue()) \(currency2)"
    }
    
    
    // MARK: - UserDefaults에서 값 불러오기
    private func loadFromUserdefaults() {
        // 여행국가화폐 불러오기
        if let savedTravelCountry = viewModel.getTravelCountry3() {
            travelCountry.text = savedTravelCountry.full
            priceCurrency.text = " \(savedTravelCountry.code)"
            currency1 = " \(savedTravelCountry.code)"
            textFieldLabel.text = "\(savedTravelCountry.code)    "
            refundCurrency.text = " \(savedTravelCountry.code)"
        }
        
        // 기준화폐 가져오기
        if let savedBaseCurrency = viewModel.getBaseCurrency3() {
            currency2 = " \(savedBaseCurrency)"
            conversionBoughtPrice.text = "\(NSLocalizedString("Approx ", comment: "")) 0 \(savedBaseCurrency)"
            conversionRefundPrice.text = "\(NSLocalizedString("Approx ", comment: "")) 0 \(savedBaseCurrency)"
        }
        
        // 부가세율 가져오기
        if let vatText = viewModel.getVatRate() {
            percent.text = vatText
        }
        
        exchangeRate.text = "\(viewModel.getTravelCurrencyUnit())\(currency1) = \(viewModel.getExchangeValue())\(currency2)"
    }
    
    
    // MARK: - AutoLayout 정의
    private func configureUI() {
        view.backgroundColor = .bgPrimary
        
        
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
            $0.bottom.equalToSuperview().inset(20)
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
        calculateCard.addSubview(conversionRefundPrice)
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
        conversionRefundPrice.snp.makeConstraints {
            $0.top.equalTo(resultStackView.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
        }
        btnStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
    
    // MARK: - 유틸리티 함수(문자열에서 숫자, 소수점, 콤마만 추출)
    /// - "약 1,234.56 USD" → "1,234.56"
    /// - "Approx 12.000,00 EUR" → "12.000,00"
    func extractNumberString(_ string: String) -> String {
        return string.components(separatedBy: CharacterSet(charactersIn: "0123456789.,").inverted).joined()
    }
    
    // 저장 완료 Alert
    private func compliteAlert() {
        alert(
            title: NSLocalizedString("Save Complete", comment: ""),
            message: NSLocalizedString("Saved successfully.", comment: "")
        )
    }
    
    
    // MARK: - 환급조건 보기 버튼 액션
    @objc
    private func checkBtnTapped() {
        let modal = RefundModal()
        present(modal, animated: true, completion: nil)
    }
    
    
    // MARK: - 계산하기 버튼 액션
    @objc
    private func calculateBtnTapped() {
        
        // MARK: 구매금액 입력 필드 예외처리
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
        
        // MARK: 구매금액 계산 로직
        if let priceValue = Double(priceText) { // 구매금액 그대로 입력
                priceNum.text = priceValue.roundedString()
            }
        let currencyCode = viewModel.getBaseCurrency3() ?? "" // 화폐단위 추출
        if let result = viewModel.conversionPrice(priceText: priceText) {
            conversionBoughtPrice.text = "\(NSLocalizedString("Approx ", comment: "")) \(result.roundedString()) \(currencyCode)"
        } else {
            conversionBoughtPrice.text = NSLocalizedString("Input Error", comment: "")
        }
        
        // MARK: 최소 구매 금액 검증
        guard let travelCountryText = travelCountry.text,
              let flag = travelCountryText.first else { return }
        let flagString = String(flag)
        
        // 환급 정책 불러오기
        guard let policy = RefundCondition.flagToPolicyMap[flagString] else { return }
        
        // 최소 주문금액 비교
        guard let priceValue = Double(priceText) else { return }
        if priceValue < policy.minimumAmount {
            refundNum.text = NSLocalizedString("Below minimum purchase", comment: "")
            refundCurrency.text = ""
            conversionRefundPrice.text = NSLocalizedString("Check refund conditions", comment: "")
            
            print("❌ 최소 주문금액 미달: \(policy.minimumAmount) 이상이어야 환급 가능") // 디버깅용
            return
        }
        
        // MARK: 환급금액(현지화폐) 계산 로직
        if let refund = viewModel.calculateVatRefund(priceText: priceText) {
            refundNum.text = refund.roundedString()
            // 환급금액을 환율로 변환해서 conversionRefuncPrice에 표시
            if let refundInBase = viewModel.convertRefundToBaseCurrency(refund: refund) {
                conversionRefundPrice.text = "\(NSLocalizedString("Approx ", comment: "")) \(refundInBase.roundedString()) \(currencyCode)"
            } else {
                conversionRefundPrice.text = NSLocalizedString("Input Error", comment: "")
            }
        } else {
            refundNum.text = NSLocalizedString("Calculate", comment: "")
            conversionRefundPrice.text = ""
        }
    }
    
    // MARK: 계산버튼 예외처리용 얼럿
    // 오입력 얼럿
    private func errorAlert1() {
        alert(
            title: NSLocalizedString("Input Error", comment: ""),
            message: NSLocalizedString("Only numbers and decimal points are allowed, and the decimal point can be entered only once.", comment: "")
        )
    }
    // 공백 입력 얼럿
    private func errorAlert2() {
        alert(
            title: NSLocalizedString("Input Error", comment: ""),
            message: NSLocalizedString("You cannot enter blank spaces.", comment: "")
        )
    }
    
    
    // MARK: - UILabel이 비어있는지 판단(기록 저장 검증용)
    private func isLabelEmpty(_ label: UILabel) -> Bool {
        let text = label.text ?? ""
        return text.isEmpty || text == "0"
    }

    
    // MARK: - 저장하기 버튼 액션
    @objc
    private func saveBtnTapped() {
        print("saveBtnTapped")
        
        // MARK: 계산을 먼저 진행했는지(계산 카드의 값들이 빈값이 아닌지) 검증
        if isLabelEmpty(priceNum) || isLabelEmpty(refundNum) {
            alert(
                title: NSLocalizedString("Error", comment: ""),
                message: NSLocalizedString("PleaseCalculateFirst", comment: "")
            )
            return
        }
        
        // MARK: 최소 구매금액 충족 검증 로직
        guard let priceText = priceTextField.text,
              let priceValue = Double(priceText),
              let travelCountryText = travelCountry.text,
              let flag = travelCountryText.first else { return }
        let flagString = String(flag)
        
        // 정책 불러오기
        guard let policy = RefundCondition.flagToPolicyMap[flagString] else { return }
        
        // 최소 주문금액 미달 체크
        if priceValue < policy.minimumAmount {
            alert(
                title: NSLocalizedString("Notice", comment: ""),
                message: NSLocalizedString("Can't save because refund is not possible below minimum purchase amount.", comment: "")
            )
            return
        }
        
        // MARK: 데이터 검증 (nil이거나 변환에 실패하지 않았는지)
        guard let country = travelCountry.text,
              let exchangeRate = exchangeRate.text,
              let priceText = priceTextField.text,
              let refundText = refundNum.text,
              let convertedPriceText = conversionBoughtPrice.text,
              let convertedText = conversionRefundPrice.text,
              let price = viewModel.parseLocalizedNumber(priceText),
              let refund = viewModel.parseLocalizedNumber(refundText),
              let convertedPrice = viewModel.parseLocalizedNumber(extractNumberString(convertedPriceText)),
              let convertedRefundPrice = viewModel.parseLocalizedNumber(extractNumberString(convertedText)) else {
            print("❌ 필수 데이터 누락 또는 변환 실패")
            return
        }

        // SavedCard 구조체 인스턴스 생성
        let card = SavedCard(
            id: UUID().uuidString,
            country: country,
            currencyCode: currency1.trimmingCharacters(in: .whitespaces),
            exchangeRate: exchangeRate,
            date: DateUtils.recordString(),
            price: price,
            refundPrice: refund,
            convertedPrice: convertedPrice,
            convertedRefundPrice: convertedRefundPrice,
            baseCurrencyCode: currency2.trimmingCharacters(in: .whitespaces)
        )

        // 저장
        viewModel.saveCard(card)
        print("✅ 저장 성공: \(card)")
        resetValues()
        compliteAlert()
    }
    
    // MARK: 기록하기 버튼 클릭시 계산결과 값들 0으로 변경
    func resetValues() {
        // 구매금액 입력 필드 공백으로 변경
        priceTextField.text = ""
        // 계산결과 카드 값들 0으로 변경
        if let baseCurrency = viewModel.getBaseCurrency3() {
            priceNum.text = "0"
            conversionBoughtPrice.text = "\(NSLocalizedString("Approx ", comment: "")) 0 \(baseCurrency)"
            refundNum.text = "0"
            conversionRefundPrice.text = "\(NSLocalizedString("Approx ", comment: "")) 0 \(baseCurrency)"
        }
    }
    
    
    // MARK: - 키보드 내리기
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
