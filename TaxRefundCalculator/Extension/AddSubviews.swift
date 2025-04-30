//
//  AddSubviews.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
