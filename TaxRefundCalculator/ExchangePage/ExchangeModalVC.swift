//
//  ExchangeModalVC.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/30/25.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

final class ExchangeModalVC: UIViewController {

    private let disposeBag = DisposeBag()

    // MARK: - UI Components

    private let containerView = UIView().then {
        $0.backgroundColor = .bgPrimary
        $0.layer.cornerRadius = 20
    }

    private let flagLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
    }

    private let currencyCodeLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 18)
    }

    private let currencyNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .currency
    }

    private let currentRateTitleLabel = UILabel().then {
        $0.text = "현재 환율"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .currency
    }

    private let currentRateLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
    }

    private let rateDiffLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }

    private let avgStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }

    private let avg3DayLabel = UILabel()
    private let avg7DayLabel = UILabel()
    private let avg1MonthLabel = UILabel()

    private let chartView = UIView().then {
        $0.backgroundColor = .subButton
        $0.layer.cornerRadius = 12
    }

    private let dismissButton = UIButton(type: .system).then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainTeal
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 10
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        view.addSubview(containerView)

        containerView.addSubviews(
            flagLabel, currencyCodeLabel, currencyNameLabel,
            currentRateTitleLabel, currentRateLabel, rateDiffLabel,
            avgStackView, chartView, dismissButton
        )

        let avgLabels = [
            (label: avg3DayLabel, title: "3일 평균"),
            (label: avg7DayLabel, title: "7일 평균"),
            (label: avg1MonthLabel, title: "1개월 평균")
        ]
        avgLabels.forEach {
            $0.label.text = "\($0.title)\n"
            $0.label.numberOfLines = 2
            $0.label.textAlignment = .center
        }

        avgStackView.addArrangedSubviews(avg3DayLabel, avg7DayLabel, avg1MonthLabel)

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        flagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().inset(24)
        }

        currencyCodeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(flagLabel.snp.trailing).offset(8)
        }

        currencyNameLabel.snp.makeConstraints {
            $0.top.equalTo(currencyCodeLabel.snp.bottom).offset(2)
            $0.leading.equalTo(currencyCodeLabel)
        }

        currentRateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(currencyNameLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }

        currentRateLabel.snp.makeConstraints {
            $0.top.equalTo(currentRateTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(currentRateTitleLabel)
        }

        rateDiffLabel.snp.makeConstraints {
            $0.top.equalTo(currentRateLabel.snp.bottom).offset(8)
            $0.leading.equalTo(currentRateTitleLabel)
        }

        avgStackView.snp.makeConstraints {
            $0.top.equalTo(rateDiffLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        chartView.snp.makeConstraints {
            $0.top.equalTo(avgStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(160)
        }

        dismissButton.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(24)
        }

        dismissButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    /// 생성 매서드
    func configure(flag: String, currencyCode: String, currencyName: String, currentRate: String, rateDiff: String, isUp: Bool) {
        flagLabel.text = flag
        currencyCodeLabel.text = currencyCode
        currencyNameLabel.text = currencyName
        currentRateLabel.text = "1 \(currencyCode) = \(currentRate)"
        rateDiffLabel.text = "\(isUp ? "▲" : "▼") 전일 대비 \(rateDiff)"
        rateDiffLabel.textColor = isUp ? .upGreen : .downRed
    }
}
