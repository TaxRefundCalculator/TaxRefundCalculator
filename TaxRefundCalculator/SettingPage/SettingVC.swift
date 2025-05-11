//
//  SettingVC.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then

class SettingVC: UIViewController {
    
    // MARK: 앱 설정 카드
    private let settingCard = UIView().then {
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let settingLabel = UILabel().then {
        $0.text = "🛠️ 앱 설정"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .left
    }
    
    // 언어변경 row
    private let changeLanguage = UILabel().then {
        $0.text = "🌏 언어 변경"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let nowLanguage = UILabel().then {
        $0.text = "한국어"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let languageRow = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // 기준 화폐 변경 row
    private let baseCurrencyChange = UILabel().then {
        $0.text = "💰 기준 화폐 변경"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let nowBaseCurrency = UILabel().then {
        $0.text = "KRW"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let baseCurrencyRow = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // 여행 화폐 변경 row
    private let currencyChange = UILabel().then {
        $0.text = "🛫 여행 화폐 변경"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let nowCurreny = UILabel().then {
        $0.text = "EUR"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let currencyRow = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // 다크모드 row
    private let darkMode = UILabel().then {
        $0.text = "🌜 다크 모드"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let darkModeSwitch = UISwitch().then {
        $0.isOn = false
        $0.onTintColor = .mainTeal
        //$0.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    private let darkModeRow = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // 리셋 row
    private let reset = UILabel().then {
        $0.text = "🗑️ 기록 초기화"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 17)
    }
    private let resetRow = UIView().then {
        $0.backgroundColor = .clear
    }
    
    
    // MARK: 앱 정보 카드
    private let infoCard = UIView().then {
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    private let infoLabel = UILabel().then {
        $0.text = "🚀 앱 정보"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    private let version = UILabel().then {
        $0.text = "버전"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        $0.textColor = .subText
    }
    private let versionNumber = UILabel().then {
        $0.text = "1.0.0"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        $0.textColor = .subText
    }
    private let update = UILabel().then {
        $0.text = "최종 업데이트"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        $0.textColor = .subText
    }
    private let updateDay = UILabel().then {
        $0.text="2025.05.11"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        $0.textColor = .subText
    }
    private let developer = UILabel().then {
        $0.text = "개발자"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        $0.textColor = .subText
    }
    private let developerName = UILabel().then {
        $0.text = "이재건, 나영진"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        $0.textColor = .subText
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    private func configureUI() {
        view.backgroundColor = .bgSecondary
        
        // MARK: Setting Card
        view.addSubview(settingCard)
        settingCard.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(360)
        }
        
        settingCard.addSubview(settingLabel)
        
        settingCard.addSubview(languageRow)
        languageRow.addSubview(changeLanguage)
        languageRow.addSubview(nowLanguage)
        
        settingCard.addSubview(baseCurrencyRow)
        baseCurrencyRow.addSubview(baseCurrencyChange)
        baseCurrencyRow.addSubview(nowBaseCurrency)
        
        settingCard.addSubview(currencyRow)
        currencyRow.addSubview(currencyChange)
        currencyRow.addSubview(nowCurreny)
        
        settingCard.addSubview(darkModeRow)
        darkModeRow.addSubview(darkMode)
        darkModeRow.addSubview(darkModeSwitch)
        
        settingCard.addSubview(resetRow)
        resetRow.addSubview(reset)
        
        settingLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
        }
        
        // Language Row Constraints
        languageRow.snp.makeConstraints {
            $0.top.equalTo(settingLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        changeLanguage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        nowLanguage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        // Base Currency Row Constraints
        baseCurrencyRow.snp.makeConstraints {
            $0.top.equalTo(languageRow.snp.bottom)
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
        nowCurreny.snp.makeConstraints {
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
        
        
        // MARK: Info Card
        view.addSubview(infoCard)
        infoCard.snp.makeConstraints {
            $0.top.equalTo(settingCard.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(160)
        }
        
        infoCard.addSubview(infoLabel)
        infoCard.addSubview(version)
        infoCard.addSubview(versionNumber)
        infoCard.addSubview(update)
        infoCard.addSubview(updateDay)
        infoCard.addSubview(developer)
        infoCard.addSubview(developerName)
        
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
        developer.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(update.snp.bottom).offset(11)
        }
        developerName.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(updateDay.snp.bottom).offset(11)
        }
        
    }
    
    
//    // MARK: 다크모드 토글스위치 액션 (구현 필요)
//    private let viewModel = SettingVM()
//
//    @objc private func switchValueChanged(_ sender: UISwitch) {
//        let result = viewModel.getNetworkStatus(isOnline: sender.isOn)
//        networkTextField.text = result.text
//        networkTextField.textColor = result.color
//    }
}
