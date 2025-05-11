//
//  LanguageModal.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 5/11/25.
//

import UIKit
import SnapKit
import SnapKit

protocol LanguageModalDelegate: AnyObject {
    func didSelectCountry(_ country: String, forFieldTag tag: Int)
}

class LanguageModal: UIViewController {
    
    weak var delegate: LanguageModalDelegate?
    var selectedTextFieldTag: Int?
    
    
    // MARK: 지원국가 목록 배열
    private let countries = [
        "🇰🇷 한국어",
        "🇯🇵 日本語",
        "🇮🇹 italiano",
        "🇩🇪 Deutsch",
        "🇫🇷 français",
        "🇪🇸 español",
        "🇺🇸 English",
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
extension LanguageModal: UITableViewDataSource {
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
extension LanguageModal: UITableViewDelegate {
    // 셀 선택 시 행동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("선택한 언어: \(countries[indexPath.row])")
        let selectedCountry = countries[indexPath.row]
        if let tag = selectedTextFieldTag {
            delegate?.didSelectCountry(selectedCountry, forFieldTag: tag)
        }
        tableView.deselectRow(at: indexPath, animated: true) // 선택 해제
        dismiss(animated: true)
    }
}
