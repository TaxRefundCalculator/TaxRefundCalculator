//
//  AddArrangedSubviews.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
