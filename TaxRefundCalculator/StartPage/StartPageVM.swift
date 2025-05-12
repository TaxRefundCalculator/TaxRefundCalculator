//
//  StartPageVM.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/28/25.
//

import UIKit
import SnapKit
import Then

class StartPageVM {
    
    //MARK: 온오프라인 토글버튼 로직
    func getNetworkStatus(isOnline: Bool) -> (text: String, color: UIColor) {
        if isOnline {
            return ("온라인 모드", .mainTeal)
        } else {
            return ("오프라인 모드", .downRed)
        }
    }
}
