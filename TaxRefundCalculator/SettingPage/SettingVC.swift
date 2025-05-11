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
        $0.text = "⚙️ 앱 설정"
        $0.textColor = .primaryText
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    private let changeLanguage = UITextView().then {
        $0.text = "언어 변경"
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
        $0.font = .systemFont(ofSize: 20, weight: .regular)
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
            $0.height.equalTo(350)
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
}
