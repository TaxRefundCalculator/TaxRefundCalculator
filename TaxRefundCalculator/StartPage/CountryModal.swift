//
//  CountryModal.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import SnapKit

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
        "🇹🇼 대만 - TWD",
        "🇻🇳 베트남 - VND",
        "🇹🇭 태국 - THB",
        "🇵🇭 필리핀 - PHP",
        "🇲🇾 말레이시아 - MYR",
        "🇸🇬 싱가포르 - SGD",
        "🇰🇭 캄보디아 - KHR",
        "🇮🇩 인도네시아 - IDR",
        "🇦🇺 호주 - AUD",
        "🇳🇿 뉴질랜드 - NZD",
        "🇦🇪 아랍에미리트 - AED",
        "🇹🇷 튀르키예 - TRY",
        "🇬🇷 그리스 - EUR",
        "🇪🇬 이집트 - EGP",
        "🇲🇦 모로코 - MAD",
        "🇹🇳 튀니지 - TND",
        "🇿🇦 남아프리카공화국 - ZAR",
        "🇨🇿 체코 - CZK",
        "🇭🇺 헝가리 - HUF",
        "🇧🇬 불가리아 - BGN",
        "🇦🇹 오스트리아 - EUR",
        "🇭🇷 크로아티아 - EUR",
        "🇮🇹 이탈리아 - EUR",
        "🇨🇭 스위스 - CHF",
        "🇩🇪 독일 - EUR",
        "🇳🇱 네덜란드 - EUR",
        "🇧🇪 벨기에 - EUR",
        "🇫🇷 프랑스 - EUR",
        "🇪🇸 스페인 - EUR",
        "🇵🇹 포르투갈 - EUR",
        "🇮🇪 아일랜드 - EUR",
        "🇸🇪 스웨덴 - SEK",
        "🇩🇰 덴마크 - DKK",
        "🇳🇴 노르웨이 - NOK",
        "🇫🇮 핀란드 - EUR",
        "🇺🇸 미국 - USD",
        "🇨🇦 캐나다 - CAD",
        "🇲🇽 멕시코 - MXN",
        "🇨🇴 콜롬비아 - COP",
        "🇧🇷 브라질 - BRL",
        "🇨🇱 칠레 - CLP",
        "🇵🇪 페루 - PEN"
    ]
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
            // 테이블뷰를 뷰에 추가
            view.addSubview(tableView)

            // 오토레이아웃 설정 (SnapKit 사용)
            tableView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }

            // 델리게이트 & 데이터소스 연결
            tableView.delegate = self
            tableView.dataSource = self

            // 셀 등록
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
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

// MARK: - UITableViewDelegate
extension CountryModal: UITableViewDelegate {
    // 셀 선택 시 행동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("선택한 국가: \(countries[indexPath.row])")
        let selectedCountry = countries[indexPath.row]
        if let tag = selectedTextFieldTag {
            delegate?.didSelectCountry(selectedCountry, forFieldTag: tag)
        }
        tableView.deselectRow(at: indexPath, animated: true) // 선택 해제
        dismiss(animated: true)
    }
}
