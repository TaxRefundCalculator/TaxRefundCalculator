//
//  StartPageVM.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class StartPageVM {
    // MARK: - UserDefaults
    let saveUserDefaults = SaveUserDefaults()
    
    // MARK: - Firebase
    private let firebaseService: FirebaseExchangeService
    private let disposeBag = DisposeBag()
    
    let exchangeRateText = BehaviorRelay<String>(value: NSLocalizedString("Unable to load exchange rate information", comment: "환율 정보를 불러올 수 없습니다"))
    
    init(firebaseService: FirebaseExchangeService) {
        self.firebaseService = firebaseService
    }
    
    // MARK: - userDefaults 저장 메서드
    func saveBaseCurrency(_ baseCurrency: String) {
        saveUserDefaults.saveBaseCurrency(baseCurrency)
    }
    func saveTravelCountry(_ travelCountry: String) {
        saveUserDefaults.saveTravelCountry(travelCountry)
    }
    func saveDoneFIrstStep(_ done: Bool) {
        saveUserDefaults.saveIsDoneFirstStep(true)
    }
    func saveTravelCurrencyUnit(_ unit: Int) {
        saveUserDefaults.saveTravelCurrencyUnit(unit)
    }
    func saveExchangeValue(_ rate: String) {
        saveUserDefaults.saveExchangeValue(rate)
    }

    
    // MARK: - 국기 인식 및 환급기준 매칭
    func getRefundPolicy(for text: String) -> (flag: String, policy: VATRefundPolicy)? {
        let flagEmojis = RefundCondition.flagToPolicyMap.keys
        for flag in flagEmojis {
            if text.contains(flag), let policy = RefundCondition.flagToPolicyMap[flag] {
                return (flag, policy)
            }
        }
        return nil
    }
    
    // MARK: - 환급 조건 텍스트 불러오기
    func refundConditionText(for country: String) -> String {
        if let (_, policy) = getRefundPolicy(for: country) {
            print("📌 환급 정책: \(policy)")
            let format = NSLocalizedString("Refund format", comment: "최소 금액, 통화, 환급율 표시")
            return String(format: format, policy.currencyCode, Int(policy.minimumAmount), policy.vatRate)
        } else {
            return NSLocalizedString("Refund policy not found", comment: "환급 정책을 찾을 수 없습니다")
        }
    }
    
    
    // MARK: - 시작하기 버튼 예외처리 로직 (빈칸, 중복 방지)
    enum StartBtnLogic {
        case valid // 문제없음
        case empty // 공백 확인
    }
    func validateInput(baseCurrency: String?, travelCountry: String?) -> StartBtnLogic {
        guard let base = baseCurrency, !base.isEmpty,
              let travel = travelCountry, !travel.isEmpty else {
            return .empty
        }
        return .valid
    }
    
    
    // MARK: - 통화코드 추출 메서드
    func extractCurrencyCode(_ text: String) -> String {
        return String(text.suffix(3))
    }
    
    
    // MARK: - 환율정보 띄우기
    func fetchExchangeText(base: String, travel: String) {
        // 텍스트 필드에서 통화코드 추출
        let baseCode = extractCurrencyCode(base)
        let travelCode = extractCurrencyCode(travel)
        
        // 오늘날짜의 파이어베이스 데이터 불러오기
        firebaseService.fetchRates(for: DateUtils.todayString())
            .subscribe(onSuccess: { [weak self] model in
                guard let self = self else { return }
                // USD 기준으로 저장된 해당 통화의 환율 불러오기
                let baseRate = model.rates[baseCode]
                let travelRate = model.rates[travelCode]
                if let baseRate = baseRate, let travelRate = travelRate {
                    // 환산단위 계산
                    let travelUnit = travelCode.displayUnit

                    // "travelUnit 단위" 만큼 환산 (예: 100 JPY = xx KRW)
                    let exchangeValue = (baseRate / travelRate) * Double(travelUnit)
                    let text = "\(travelUnit) \(travelCode) = \(exchangeValue.roundedString(fractionDigits: 2)) \(baseCode)"
                    // UserDefaults에 저장
                    self.saveTravelCurrencyUnit(travelUnit)
                    self.saveExchangeValue(exchangeValue.roundedString(fractionDigits: 2))
                    self.exchangeRateText.accept(text)
                } else {
                    self.exchangeRateText.accept(NSLocalizedString("Unable to load exchange rate information", comment: "환율 정보를 불러올 수 없습니다"))
                }
            }, onFailure: { [weak self] _ in
                self?.exchangeRateText.accept(NSLocalizedString("Unable to load exchange rate information", comment: "환율 정보를 불러올 수 없습니다"))
            })
            .disposed(by: disposeBag)
    }
    
}
