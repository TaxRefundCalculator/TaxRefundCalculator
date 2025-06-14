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
        "🇰🇷 대한민국 - KRW",
        "🇯🇵 일본 - JPY",
        "🇺🇸 미국 - USD",
        "🇬🇧 영국 - GBP",
        "🇹🇭 태국 - THB",
        "🇲🇾 말레이시아 - MYR",
        "🇸🇬 싱가포르 - SGD",
        "🇮🇩 인도네시아 - IDR",
        "🇦🇺 호주 - AUD",
        "🇹🇷 튀르키예 - TRY",
        "🇿🇦 남아프리카공화국 - ZAR",
        "🇨🇿 체코 - CZK",
        "🇭🇺 헝가리 - HUF",
        "🇧🇬 불가리아 - BGN",
        "🇨🇭 스위스 - CHF",
        "🇩🇪 독일 - EUR",
        "🇳🇱 네덜란드 - EUR",
        "🇧🇪 벨기에 - EUR",
        "🇫🇷 프랑스 - EUR",
        "🇪🇸 스페인 - EUR",
        "🇵🇹 포르투갈 - EUR",
        "🇮🇪 아일랜드 - EUR",
        "🇦🇹 오스트리아 - EUR",
        "🇭🇷 크로아티아 - EUR",
        "🇮🇹 이탈리아 - EUR",
        "🇬🇷 그리스 - EUR",
        "🇸🇪 스웨덴 - SEK",
        "🇩🇰 덴마크 - DKK",
        "🇳🇴 노르웨이 - NOK",
        "🇫🇮 핀란드 - EUR",
        "🇲🇽 멕시코 - MXN",
        "🇧🇷 브라질 - BRL",
        "🇵🇱 폴란드 - PLN",
        "🇷🇴 루마니아 - RON",
        "🇮🇸 아이슬란드 - ISK",
        "🇷🇺 러시아 - RUB",
        "🇮🇱 이스라엘 - ILS",
        "🇮🇳 인도 - INR"
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
            // tag == 2 (여행국가)에서만 USD/GBP 제한 적용
            if tag == 2 && (selectedCountry.contains("USD") || selectedCountry.contains("GBP")) {
                let alert = UIAlertController(
                    title: "알림",
                    message: "해당 국가는 택스리펀을 하지 않습니다.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
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
