//
//  AlertHelper.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 7/4/25.
//

import UIKit

extension UIViewController {
    // 일반 얼럿
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        self.present(alert, animated: true)
    }
    
    // 확인/취소 얼럿
    func confirmAlert(
        title: String,
        message: String,
        confirmTitle: String = NSLocalizedString("Yes", comment: ""),
        cancelTitle: String = NSLocalizedString("No", comment: ""),
        confirmStyle: UIAlertAction.Style = .destructive,
        confirmHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in
            confirmHandler?()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}
