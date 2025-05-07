import UIKit
import SnapKit
import Then

final class ExchangeCell: UITableViewCell {
    
    // MARK: - UI Components

    static let id = "ExchangeCell"

    private let flagLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
    }

    private let currencyCodeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.numberOfLines = 0
    }

    private let currencyNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .currency
        $0.numberOfLines = 0
    }

    private let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textAlignment = .right
        $0.numberOfLines = 0
    }

    private let codeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }

    private let diffLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .right
        $0.numberOfLines = 0
    }

    private let upArrow = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.up")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .upGreen
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }

    private let downArrow = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .downRed
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupUI() {
        backgroundColor = .bgPrimary
        contentView.backgroundColor = .bgPrimary

        contentView.addSubviews(flagLabel, currencyCodeLabel, currencyNameLabel,
                             priceLabel, codeLabel, diffLabel, upArrow, downArrow)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        flagLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        currencyCodeLabel.snp.makeConstraints {
            $0.leading.equalTo(flagLabel.snp.trailing).offset(12)
            $0.top.equalToSuperview().inset(16)
        }

        currencyNameLabel.snp.makeConstraints {
            $0.leading.equalTo(currencyCodeLabel)
            $0.top.equalTo(currencyCodeLabel.snp.bottom).offset(2)
            $0.bottom.lessThanOrEqualToSuperview().inset(16)
        }

        priceLabel.snp.makeConstraints {
            $0.trailing.equalTo(codeLabel.snp.leading).offset(-4)
            $0.centerY.equalTo(currencyCodeLabel)
        }

        codeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(priceLabel)
        }

        diffLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(currencyNameLabel)
            $0.bottom.lessThanOrEqualToSuperview().inset(12)
        }

        upArrow.snp.makeConstraints {
            $0.trailing.equalTo(diffLabel.snp.leading).offset(-2)
            $0.centerY.equalTo(diffLabel)
            $0.width.height.equalTo(10)
        }

        downArrow.snp.makeConstraints {
            $0.trailing.equalTo(diffLabel.snp.leading).offset(-2)
            $0.centerY.equalTo(diffLabel)
            $0.width.height.equalTo(10)
        }
    }

    // MARK: - Bind

    func bind(model: ExchangeRateModel) {
        flagLabel.text = model.flag
        currencyCodeLabel.text = model.currencyCode
        currencyNameLabel.text = model.currencyName
        priceLabel.text = model.formattedRate
        codeLabel.text = model.currencyCode
        diffLabel.text = model.diffPercentage

        let isUp = model.isUp
        upArrow.isHidden = !isUp
        downArrow.isHidden = isUp
        diffLabel.textColor = isUp ? .upGreen : .downRed
    }
}
