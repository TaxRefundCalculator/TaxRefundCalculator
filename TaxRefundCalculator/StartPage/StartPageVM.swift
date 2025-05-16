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
    
    func getRefundPolicy(for text: String) -> VATRefundPolicy? {
        // 추출 가능한 이모지 범위로 가정: 국기 이모지 유니코드는 대부분 두 글자
        let flagEmojis = RefundCondition.flagToPolicyMap.keys

        for flag in flagEmojis {
            if text.contains(flag) {
                return RefundCondition.flagToPolicyMap[flag]
            }
        }

        return nil
    }
}
