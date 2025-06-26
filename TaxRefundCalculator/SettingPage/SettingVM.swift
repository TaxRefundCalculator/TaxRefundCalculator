//
//  SettingVM.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import Foundation
import SnapKit
import Then
import Combine
import RxSwift

class SettingVM {
    
    // MARK: 싱글톤 패턴
    static let shared = SettingVM()
    private init() { // 외부에서 생성 방지
        // 반드시 UserDefaults 값으로 @Published 초기화
        self.baseCurrency = saveUserDefaults.getBaseCurrency() ?? ""
        self.travelCountry = saveUserDefaults.getTravelCountry() ?? ""
        setupCombineBindings()
    }
    // MARK: Combine - 환율 정보, 환폐단위 최신화
    @Published var exchangeValue: String = ""
    @Published var travelCurrencyUnit: Int = 1
    
    var firebaseService: FirebaseExchangeService!
    private let disposeBag = DisposeBag()
    
    // MARK: Combine - 기존화폐, 여행화폐 변경시 최신화를 위함
    @Published var baseCurrency: String = ""
    @Published var travelCountry: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    let saveUserDefaults = SaveUserDefaults()
    
    // MARK: userDefaults 저장 메서드
//    func saveSelectedLanguage(_ language: String) {
//        saveUserDefaults.saveLanguage(language)
//    }
    func saveBaseCurrency(_ baseCurrency: String) {
        saveUserDefaults.saveBaseCurrency(baseCurrency) // 유저디폴트에 저장
        self.baseCurrency = baseCurrency // @Published 갱신
    }
    func saveTravelCountry(_ travelCountry: String) {
        saveUserDefaults.saveTravelCountry(travelCountry) // 유저디폴트에 저장
        self.travelCountry = travelCountry // @Published 갱신
    }
    func saveTravelCurrencyUnit(_ travelCurrencyUnit: Int) {
        saveUserDefaults.saveTravelCurrencyUnit(travelCurrencyUnit)
        self.travelCurrencyUnit = travelCurrencyUnit
    }
    func saveExchangeValue(_ exchangeValue: String) {
        saveUserDefaults.saveExchangeValue(exchangeValue)
        self.exchangeValue = exchangeValue
    }
    
    // MARK: userDefaults 조회 메서드
//    func getSelectedLanguage() -> String? {
//        return saveUserDefaults.getLanguage()
//    }
    func getBaseCurrency() -> String? {
        return saveUserDefaults.getBaseCurrency()
    }
    func getTravelCountry() -> String? {
        return saveUserDefaults.getTravelCountry()
    }
    
    // MARK: 다크모드
    // 저장
    func saveDarkModeEnabled(_ enabled: Bool) {
        saveUserDefaults.saveDarkModeEnabled(enabled)
    }
    // 조회
    func getDarkModeEnabled() -> Bool {
        saveUserDefaults.getDarkModeEnabled()
    }
    
    // MARK: 기록 초기화
    func deleteAllRecords() {
        saveUserDefaults.deleteAllRecords()
    }
    
    private func setupCombineBindings() {
        // 기준 화폐가 변경되었을 때
        $baseCurrency
            .dropFirst() // 초기값 무시
            .sink { [weak self] value in
                self?.updateExchangeInfoAfterCurrencyChange()
            }
            .store(in: &cancellables)
        // 여행 화폐도 동일하게 바인딩 (필요 시)
        $travelCountry
            .dropFirst()
            .sink { [weak self] _ in
                self?.updateExchangeInfoAfterCurrencyChange()
            }
            .store(in: &cancellables)
    }
    
    func updateExchangeInfoAfterCurrencyChange() {
        guard let base = getBaseCurrency(), let travel = getTravelCountry(), !base.isEmpty, !travel.isEmpty else { return }
        let baseCode = String(base.suffix(3))
        let travelCode = String(travel.suffix(3))
        firebaseService.fetchRates(for: DateUtils.todayString())
            .subscribe(onSuccess: { [weak self] model in
                if let baseRate = model.rates[baseCode], let travelRate = model.rates[travelCode] {
                    let travelUnit = travelCode.displayUnit
                    let exchangeValue = (baseRate / travelRate) * Double(travelUnit)
                    self?.saveTravelCurrencyUnit(travelUnit)
                    self?.saveExchangeValue(exchangeValue.roundedString(fractionDigits: 2))
                    // @Published 값 직접 갱신
                    self?.travelCurrencyUnit = travelUnit
                    self?.exchangeValue = exchangeValue.roundedString(fractionDigits: 2)
                }
            }, onFailure: { error in
                print("❌ [UserDefaults][Setting] 파이어베이스 fetchRates 실패:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
}
