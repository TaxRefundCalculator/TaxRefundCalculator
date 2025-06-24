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
    
    private let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textAlignment = .right
        $0.numberOfLines = 0
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
        backgroundColor = .bgSecondary
        contentView.backgroundColor = .bgSecondary
        
        contentView.addSubviews(flagLabel, currencyCodeLabel,
                                priceLabel)
        
        flagLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        currencyCodeLabel.snp.makeConstraints {
            $0.leading.equalTo(flagLabel.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    func bind(model: ExchangeRateModel) {
        flagLabel.text = model.flag
        currencyCodeLabel.text = model.currencyCode
        
        let fullText = model.formattedRate
        
        // " = "을 기준으로 색상 적용
        if let range = fullText.range(of: " = ") {
            let prefix = String(fullText[..<range.upperBound])   // "100 JPY = "
            let highlight = String(fullText[range.upperBound...]) // "8.21 KRW"
            
            let attrString = NSMutableAttributedString(
                string: prefix,
                attributes: [
                    .foregroundColor: UIColor.currency
                ]
            )
            let highlightAttr = NSAttributedString(
                string: highlight,
                attributes: [
                    .foregroundColor: UIColor.mainTeal
                ]
            )
            attrString.append(highlightAttr)
            priceLabel.attributedText = attrString
        } else {
            priceLabel.text = fullText
        }
    }
}
