//
//  CountryModal.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then

protocol CountryModalDelegate: AnyObject {
    func didSelectCountry(_ country: String, forFieldTag tag: Int)
}

class CountryModal: UIViewController {
    
    weak var delegate: CountryModalDelegate?
    var selectedTextFieldTag: Int?
    
    
    // MARK: 지원국가 목록 배열
    private let countries = [
        "🇰🇷 \(NSLocalizedString("South Korea - KRW", comment: ""))",
        "🇯🇵 \(NSLocalizedString("Japan - JPY", comment: ""))",
        "🇺🇸 \(NSLocalizedString("USA - USD", comment: ""))",
        "🇬🇧 \(NSLocalizedString("UK - GBP", comment: ""))",
        "🇦🇺 \(NSLocalizedString("Australia - AUD", comment: ""))",
        "🇩🇪 \(NSLocalizedString("Germany - EUR", comment: ""))",
        "🇳🇱 \(NSLocalizedString("Netherlands - EUR", comment: ""))",
        "🇧🇪 \(NSLocalizedString("Belgium - EUR", comment: ""))",
        "🇫🇷 \(NSLocalizedString("France - EUR", comment: ""))",
        "🇪🇸 \(NSLocalizedString("Spain - EUR", comment: ""))",
        "🇵🇹 \(NSLocalizedString("Portugal - EUR", comment: ""))",
        "🇮🇪 \(NSLocalizedString("Ireland - EUR", comment: ""))",
        "🇦🇹 \(NSLocalizedString("Austria - EUR", comment: ""))",
        "🇭🇷 \(NSLocalizedString("Croatia - EUR", comment: ""))",
        "🇮🇹 \(NSLocalizedString("Italy - EUR", comment: ""))",
        "🇬🇷 \(NSLocalizedString("Greece - EUR", comment: ""))",
        "🇸🇪 \(NSLocalizedString("Sweden - SEK", comment: ""))",
        "🇩🇰 \(NSLocalizedString("Denmark - DKK", comment: ""))",
        "🇳🇴 \(NSLocalizedString("Norway - NOK", comment: ""))",
        "🇫🇮 \(NSLocalizedString("Finland - EUR", comment: ""))",
        "🇮🇸 \(NSLocalizedString("Iceland - ISK", comment: ""))",
        "🇨🇭 \(NSLocalizedString("Switzerland - CHF", comment: ""))",
        "🇨🇿 \(NSLocalizedString("Czech - CZK", comment: ""))",
        "🇭🇺 \(NSLocalizedString("Hungary - HUF", comment: ""))",
        "🇧🇬 \(NSLocalizedString("Bulgaria - BGN", comment: ""))",
        "🇵🇱 \(NSLocalizedString("Poland - PLN", comment: ""))",
        "🇷🇴 \(NSLocalizedString("Romania - RON", comment: ""))",
        "🇹🇷 \(NSLocalizedString("Türkiye - TRY", comment: ""))",
        "🇷🇺 \(NSLocalizedString("Russia - RUB", comment: ""))",
        "🇹🇭 \(NSLocalizedString("Thailand - THB", comment: ""))",
        "🇲🇾 \(NSLocalizedString("Malaysia - MYR", comment: ""))",
        "🇸🇬 \(NSLocalizedString("Singapore - SGD", comment: ""))",
        "🇮🇩 \(NSLocalizedString("Indonesia - IDR", comment: ""))",
        "🇮🇳 \(NSLocalizedString("India - INR", comment: ""))",
        "🇮🇱 \(NSLocalizedString("Israel - ILS", comment: ""))",
        "🇲🇽 \(NSLocalizedString("Mexico - MXN", comment: ""))",
        "🇧🇷 \(NSLocalizedString("Brazil - BRL", comment: ""))",
        "🇿🇦 \(NSLocalizedString("South Africa - ZAR", comment: ""))"
    ]
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.5 // 현재 화면의 절반 높이
            })]
            sheet.prefersGrabberVisible = true // 상단에 작은 Grabber를 표시할지 여부
            sheet.preferredCornerRadius = 20   // 둥근 모서리 설정
        }
    }
    
    private func setupTableView() {
        // 테이블뷰를 뷰에 추가
        view.addSubview(tableView)
        
        // 오토레이아웃 설정
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 델리게이트 & 데이터소스 연결
        tableView.delegate = self
        tableView.dataSource = self
        
        // 셀 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
        
        // Grabber와 첫 번째 셀 사이 간격
        tableView.contentInset.top = 16
        tableView.setContentOffset(CGPoint(x: 0, y: -16), animated: false)
    }
}

// MARK: - UITableViewDataSource
extension CountryModal: UITableViewDataSource {
    // 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    // 셀 생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀 재사용
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row] // 텍스트 설정
        return cell
    }
}

// MARK: - UITableViewDelegate (셀 선택시)
extension CountryModal: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = countries[indexPath.row]
        print("\(countries[indexPath.row])") // 선택된 국가
        
        if let tag = selectedTextFieldTag {
            // tag == 1 (여행국가)에서만 USD/GBP 제한 적용
            if tag == 1 && (selectedCountry.contains("USD") || selectedCountry.contains("GBP")) {
                let alert = UIAlertController(
                    title: "\(NSLocalizedString("Notice", comment: ""))",
                    message: "\(NSLocalizedString("This country does not provide tax refund.", comment: ""))",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "\(NSLocalizedString("OK", comment: ""))", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            delegate?.didSelectCountry(selectedCountry, forFieldTag: tag)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
}
