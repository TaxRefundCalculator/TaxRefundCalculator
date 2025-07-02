//
//  SettingVC.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then

class SettingVC: UIViewController, CountryModalDelegate {
    
    private let viewModel = SettingVM.shared // 싱글턴 패턴이기때문에 싱글턴 인스턴스. 새로 생성하면 안됨.
    
    // MARK: - 앱 설정 카드
    private let settingCard = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let settingLabel = UILabel().then {
        $0.text = "🛠️ \(NSLocalizedString("App Settings", comment: ""))"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .left
    }
    
    // 기준 화폐 변경 row
    private let baseCurrencyChange = UILabel().then {
        $0.text = "💰 \(NSLocalizedString("Base Currency", comment: ""))"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let nowBaseCurrency = UILabel().then {
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let baseCurrencyRow = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // 여행 화폐 변경 row
    private let currencyChange = UILabel().then {
        $0.text = "🛫 \(NSLocalizedString("Travel Country", comment: ""))"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let nowCurrency = UILabel().then {
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let currencyRow = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // 다크모드 row
    private let darkMode = UILabel().then {
        $0.text = "🌜 \(NSLocalizedString("Dark Mode", comment: ""))"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let darkModeSwitch = UISwitch().then {
        $0.isOn = false
        $0.onTintColor = .mainTeal
        $0.addTarget(self, action: #selector(darkModeSwitchChanged), for: .valueChanged)
    }
    private let darkModeRow = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // 리셋 row
    private let reset = UILabel().then {
        $0.text = "🗑️ \(NSLocalizedString("Reset Records", comment: ""))"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let resetRow = UIView().then {
        $0.backgroundColor = .clear
    }
    
    
    // MARK: - 앱 정보 카드
    private let infoCard = UIView().then {
        $0.backgroundColor = .bgSecondary
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let infoLabel = UILabel().then {
        $0.text = "🚀 \(NSLocalizedString("App Info", comment: ""))"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    private let version = UILabel().then {
        $0.text = NSLocalizedString("Version", comment: "")
        $0.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        $0.textColor = .subText
    }
    private let versionNumber = UILabel().then {
        $0.text = "1.0.0"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        $0.textColor = .subText
    }
    private let update = UILabel().then {
        $0.text = NSLocalizedString("Last Updated", comment: "")
        $0.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        $0.textColor = .subText
    }
    private let updateDay = UILabel().then {
        $0.text = "2025.06.27"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        $0.textColor = .subText
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        loadFromUserdefaults()
    }
    
    
    // MARK: - UserDefaults에서 값 불러오기
    private func loadFromUserdefaults() {
        // 기준화폐 설정
        if let loadBaseCurrency = viewModel.getBaseCurrency() {
            nowBaseCurrency.text = loadBaseCurrency
        }
        // 여행화폐 설정
        if let loadTravelCountry = viewModel.getTravelCountry() {
            nowCurrency.text = loadTravelCountry
        }
        // 다크모드 스위치 활성화 체크
        darkModeSwitch.isOn = viewModel.getDarkModeEnabled()
    }
    
    
    // MARK: - AutoLayout 정의
    private func configureUI() {
        view.backgroundColor = .bgPrimary
        
        // MARK: Setting Card
        view.addSubview(settingCard)
        settingCard.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(310)
        }
        
        settingCard.addSubview(settingLabel)
    
        settingCard.addSubview(baseCurrencyRow)
        baseCurrencyRow.addSubview(baseCurrencyChange)
        baseCurrencyRow.addSubview(nowBaseCurrency)
        
        settingCard.addSubview(currencyRow)
        currencyRow.addSubview(currencyChange)
        currencyRow.addSubview(nowCurrency)
        
        settingCard.addSubview(darkModeRow)
        darkModeRow.addSubview(darkMode)
        darkModeRow.addSubview(darkModeSwitch)
        
        settingCard.addSubview(resetRow)
        resetRow.addSubview(reset)
        
        // 제목
        settingLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
        }

        // Base Currency Row Constraints
        baseCurrencyRow.snp.makeConstraints {
            $0.top.equalTo(settingLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        baseCurrencyChange.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        nowBaseCurrency.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        // Currency Row Constraints
        currencyRow.snp.makeConstraints {
            $0.top.equalTo(baseCurrencyRow.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        currencyChange.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        nowCurrency.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        // Dark Mode Row Constraints
        darkModeRow.snp.makeConstraints {
            $0.top.equalTo(currencyRow.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        darkMode.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        darkModeSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        // Reset Row Constraints
        resetRow.snp.makeConstraints {
            $0.top.equalTo(darkModeRow.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        reset.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        // Set tag values for baseCurrencyRow and currencyRow
        baseCurrencyRow.tag = 0
        currencyRow.tag = 1

        
        //MARK: - 각 row 클릭시
        let baseTap = UITapGestureRecognizer(target: self, action: #selector(didTapBaseCurrencyRow))
        baseCurrencyRow.addGestureRecognizer(baseTap)
        baseCurrencyRow.isUserInteractionEnabled = true
        let travelTap = UITapGestureRecognizer(target: self, action: #selector(didTapTravelCountryRow))
        currencyRow.addGestureRecognizer(travelTap)
        currencyRow.isUserInteractionEnabled = true
        let resetTap = UITapGestureRecognizer(target: self, action: #selector(didTapResetRow))
        resetRow.addGestureRecognizer(resetTap)
        resetRow.isUserInteractionEnabled = true
        
        
        // MARK: - Info Card
        view.addSubview(infoCard)
        infoCard.snp.makeConstraints {
            $0.top.equalTo(settingCard.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(130)
        }
        
        infoCard.addSubview(infoLabel)
        infoCard.addSubview(version)
        infoCard.addSubview(versionNumber)
        infoCard.addSubview(update)
        infoCard.addSubview(updateDay)
        
        infoLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(16)
        }
        version.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(infoLabel.snp.bottom).offset(20)
        }
        versionNumber.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(infoLabel.snp.bottom).offset(20)
        }
        update.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(version.snp.bottom).offset(11)
        }
        updateDay.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(version.snp.bottom).offset(11)
        }
        
    }
    

    // MARK: - Tap Actions 클릭시 모달로 출력
    @objc
    private func didTapBaseCurrencyRow() {
        let modal = CountryModal()
        modal.delegate = self
        modal.selectedTextFieldTag = baseCurrencyRow.tag
        modal.currentBaseCurrency = nowBaseCurrency.text
        modal.currentTravelCurrency = nowCurrency.text
        modal.modalPresentationStyle = .pageSheet
        present(modal, animated: true, completion: nil)
    }
    @objc
    private func didTapTravelCountryRow() {
        let modal = CountryModal()
        modal.delegate = self
        modal.selectedTextFieldTag = currencyRow.tag
        modal.currentBaseCurrency = nowBaseCurrency.text
        modal.currentTravelCurrency = nowCurrency.text
        modal.modalPresentationStyle = .pageSheet
        present(modal, animated: true, completion: nil)
    }
    @objc
    private func didTapResetRow() {
        let alert = UIAlertController(title: NSLocalizedString("Delete Records", comment: ""), message: NSLocalizedString("Do you want to delete all records?", comment: ""), preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive) { _ in
                
                self.viewModel.deleteAllRecords()
                print("기록 삭제됨")
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil)
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
    }


    // MARK: - Delegate Methods
    // 화폐 선택 부분들
    func didSelectCountry(_ country: String, forFieldTag tag: Int) {
        switch tag {
        case 0:
            nowBaseCurrency.text = country
            SettingVM.shared.saveBaseCurrency(country)
        case 1:
            nowCurrency.text = country
            SettingVM.shared.saveTravelCountry(country) // userDefaults에 저장 및 Combine
        default:
            break
        }
    }
    
    
    // MARK: - 다크모드 토글 스위치 액션
    @objc
    private func darkModeSwitchChanged(_ sender: UISwitch) {
        viewModel.saveDarkModeEnabled(sender.isOn)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in scene.windows {
                window.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
            }
        }
    }

}
