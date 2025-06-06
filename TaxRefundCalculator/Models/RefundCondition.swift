//
//  RefundCondition.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 5/15/25.
//

import Foundation

struct VATRefundPolicy: Codable {
    let country: String
    let currencyCode: String
    let vatRate: Double
    let vatRefund: Double
    let minimumAmount: Double
    let refundRateDescription: String
    let eligibleBuyers: String
    let eligibleItems: String
    let refundMethod: String
    let refundPlace: String
    let notes: String
}

let koreaPolicy = VATRefundPolicy(
    country: "대한민국",
    currencyCode: "KRW",
    vatRate: 10.0,
    vatRefund: 0.07,
    minimumAmount: 15000.0,
    refundRateDescription: "구매 금액의 최대 7%",
    eligibleBuyers: "한국에 6개월 미만 체류한 외국인, 한국에 3개월 미만 체류하며 해외에 2년 이상 거주한 해외 교포",
    eligibleItems: "미개봉 및 미사용 상태의 과세 물품, 구매일로부터 3개월 이내에 출국 시 반출하는 물품",
    refundMethod: "즉시 환급: 일부 매장에서 구매 시 즉시 세금 차감, 시내 환급: 도심 환급소에서 환급, 공항 환급: 출국 시 공항 환급소 또는 키오스크에서 환급",
    refundPlace: "인천국제공항 및 주요 공항의 환급 카운터 또는 키오스크, 서울 등 주요 도시의 시내 환급소",
    notes: "환급 금액은 구매 금액의 최대 약 7%까지 가능하며, 환급 수수료 및 환율 변동에 따라 실제 환급액은 달라질 수 있습니다. 세관에서 구매 물품에 대한 확인 도장을 받아야 합니다."
)

let japanPolicy = VATRefundPolicy(
    country: "일본",
    currencyCode: "JPY",
    vatRate: 10.0,
    vatRefund: 0.1,
    minimumAmount: 5000.0,
    refundRateDescription: "구매 시 즉시 면세",
    eligibleBuyers: "외국인 관광객",
    eligibleItems: "일반 상품",
    refundMethod: "면세 (구매 시 즉시)",
    refundPlace: "면세점",
    notes: "2026년부터 환급 제도 도입 예정 (현재는 면세)"
)

let thailandPolicy = VATRefundPolicy(
    country: "태국",
    currencyCode: "THB",
    vatRate: 7.0,
    vatRefund: 0.07,
    minimumAmount: 2000.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "외국인 관광객",
    eligibleItems: "승인된 매장에서 구매한 물품, 60일 이내 출국 시 반출하는 물품",
    refundMethod: "공항 환급",
    refundPlace: "출국장 VAT 환급 창구",
    notes: "승인된 매장에서 구매, 60일 이내 출국"
)

let malaysiaPolicy = VATRefundPolicy(
    country: "말레이시아",
    currencyCode: "MYR",
    vatRate: 6.0,
    vatRefund: 0.06,
    minimumAmount: 300.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "외국인 관광객",
    eligibleItems: "승인된 매장에서 구매한 물품",
    refundMethod: "공항 환급",
    refundPlace: "공항 VAT 환급 카운터",
    notes: "관광세청 승인 매장에서만 가능"
)

let singaporePolicy = VATRefundPolicy(
    country: "싱가포르",
    currencyCode: "SGD",
    vatRate: 9.0,
    vatRefund: 0.09,
    minimumAmount: 100.0,
    refundRateDescription: "GST 환급",
    eligibleBuyers: "외국인 관광객",
    eligibleItems: "싱가포르를 떠날 때 반출하는 물품, 일부 품목 제외",
    refundMethod: "전자환급 (eTRS)",
    refundPlace: "공항 eTRS 키오스크",
    notes: "여권 등록 필수, 일부 품목 제외"
)

let indonesiaPolicy = VATRefundPolicy(
    country: "인도네시아",
    currencyCode: "IDR",
    vatRate: 11.0,
    vatRefund: 0.11,
    minimumAmount: 500000.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "외국인 관광객, 승무원 등 제외",
    eligibleItems: "국외로 반출하는 물품",
    refundMethod: "공항 환급",
    refundPlace: "VAT 환급 오피스",
    notes: "승무원 등은 환급 불가"
)

let australiaPolicy = VATRefundPolicy(
    country: "호주",
    currencyCode: "AUD",
    vatRate: 10.0,
    vatRefund: 0.1,
    minimumAmount: 300.0,
    refundRateDescription: "GST 환급",
    eligibleBuyers: "외국인 관광객",
    eligibleItems: "출국 30일 이내 구매한 물품",
    refundMethod: "공항 환급 (TRS)",
    refundPlace: "출국장 TRS 카운터",
    notes: "출국 30일 이내 구매, 최소 90분 전 도착 권장"
)

let turkeyPolicy = VATRefundPolicy(
    country: "튀르키예",
    currencyCode: "TRY",
    vatRate: 18.0,
    vatRefund: 0.18,
    minimumAmount: 100.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "외국인 관광객",
    eligibleItems: "승인된 품목",
    refundMethod: "공항 환급",
    refundPlace: "세관 인증 후 환급 창구",
    notes: "승인된 품목에 한함"
)

let southAfricaPolicy = VATRefundPolicy(
    country: "남아프리카공화국",
    currencyCode: "ZAR",
    vatRate: 15.0,
    vatRefund: 0.15,
    minimumAmount: 250.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "외국인 관광객",
    eligibleItems: "국외로 반출하는 물품",
    refundMethod: "공항 환급",
    refundPlace: "VAT 환급소",
    notes: "세관 확인 필요"
)

let czechRepublicPolicy = VATRefundPolicy(
    country: "체코",
    currencyCode: "CZK",
    vatRate: 21.0,
    vatRefund: 0.21,
    minimumAmount: 2001.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "외국인 관광객",
    eligibleItems: "90일 이내 출국 시 반출하는 물품",
    refundMethod: "공항 환급",
    refundPlace: "출국장 환급 창구",
    notes: "세관 도장 필수, 90일 이내 출국"
)

let hungaryPolicy = VATRefundPolicy(
    country: "헝가리",
    currencyCode: "HUF",
    vatRate: 27.0,
    vatRefund: 0.27,
    minimumAmount: 54001.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "외국인 관광객",
    eligibleItems: "국외로 반출하는 물품",
    refundMethod: "공항 환급",
    refundPlace: "세관 및 환급소",
    notes: "영수증 지참 필수"
)

let bulgariaPolicy = VATRefundPolicy(
    country: "불가리아",
    currencyCode: "BGN",
    vatRate: 20.0,
    vatRefund: 0.2,
    minimumAmount: 125.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "외국인 관광객",
    eligibleItems: "국외로 반출하는 물품",
    refundMethod: "공항 환급",
    refundPlace: "환급 창구",
    notes: "세관 확인 필요"
)

let switzerlandPolicy = VATRefundPolicy(
    country: "스위스",
    currencyCode: "CHF",
    vatRate: 7.7,
    vatRefund: 0.077,
    minimumAmount: 300.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비거주자",
    eligibleItems: "국외로 반출하는 물품",
    refundMethod: "공항 환급",
    refundPlace: "제휴업체 또는 환급소",
    notes: "비EU 국적자만 가능"
)

let germanyPolicy = VATRefundPolicy(
    country: "독일",
    currencyCode: "EUR",
    vatRate: 19.0,
    vatRefund: 0.19,
    minimumAmount: 50.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "EU 외 지역으로 반출하는 물품",
    refundMethod: "공항 환급",
    refundPlace: "Global Blue / Planet 환급소",
    notes: "세관 도장 필수"
)

let netherlandsPolicy = VATRefundPolicy(
    country: "네덜란드",
    currencyCode: "EUR",
    vatRate: 21.0,
    vatRefund: 0.21,
    minimumAmount: 50.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "EU 외 지역으로 반출하는 물품",
    refundMethod: "공항 환급",
    refundPlace: "세관 도장 후 환급 창구",
    notes: "당일 출국 시 환급 어려움"
)

let belgiumPolicy = VATRefundPolicy(
    country: "벨기에",
    currencyCode: "EUR",
    vatRate: 21.0,
    vatRefund: 0.21,
    minimumAmount: 125.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "승인된 매장에서 구매한 물품",
    refundMethod: "공항 환급",
    refundPlace: "환급소",
    notes: "승인된 매장, 세관 확인 필요"
)

let francePolicy = VATRefundPolicy(
    country: "프랑스",
    currencyCode: "EUR",
    vatRate: 20.0,
    vatRefund: 0.20,
    minimumAmount: 100.01,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "EU 외 지역으로 반출하는 물품",
    refundMethod: "PABLO 전자 인증 또는 환급소",
    refundPlace: "공항",
    notes: "수수료 약 12% 차감"
)

let spainPolicy = VATRefundPolicy(
    country: "스페인",
    currencyCode: "EUR",
    vatRate: 21.0,
    vatRefund: 0.21,
    minimumAmount: 90.15,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "EU 외 지역으로 반출하는 물품",
    refundMethod: "DIVA 키오스크",
    refundPlace: "공항",
    notes: "전자 인증 필수"
)

let portugalPolicy = VATRefundPolicy(
    country: "포르투갈",
    currencyCode: "EUR",
    vatRate: 23.0,
    vatRefund: 0.23,
    minimumAmount: 61.50,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "EU 외 지역으로 반출하는 물품",
    refundMethod: "공항 환급",
    refundPlace: "환급 창구",
    notes: "90일 이내 출국"
)

let irelandPolicy = VATRefundPolicy(
    country: "아일랜드",
    currencyCode: "EUR",
    vatRate: 23.0,
    vatRefund: 0.23,
    minimumAmount: 75.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "개인 사용을 위한 물품, 구매일로부터 3개월 이내에 EU를 떠날 때 개인 수하물로 반출되는 상품",
    refundMethod: "소매점 또는 환급 대행사",
    refundPlace: "더블린, 섀넌 공항 등",
    notes: "일부 상점만 참여, 구매 전 확인 필요"
)

let austriaPolicy = VATRefundPolicy(
    country: "오스트리아",
    currencyCode: "EUR",
    vatRate: 20.0,
    vatRefund: 0.20,
    minimumAmount: 75.01,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품, 구매일로부터 3개월 이내에 EU를 떠날 때 개인 수하물로 반출되는 상품",
    refundMethod: "공항 환급 또는 시내 환급소",
    refundPlace: "비엔나 공항 등",
    notes: "세관 도장 필수, 영수증 및 상품 제시"
)

let croatiaPolicy = VATRefundPolicy(
    country: "크로아티아",
    currencyCode: "EUR",
    vatRate: 25.0,
    vatRefund: 0.25,
    minimumAmount: 100.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품, 구매일로부터 3개월 이내에 EU를 떠날 때 개인 수하물로 반출되는 상품",
    refundMethod: "공항 환급",
    refundPlace: "자그레브 공항 등",
    notes: "세관 도장 필수, 영수증 및 상품 제시"
)

let italyPolicy = VATRefundPolicy(
    country: "이탈리아",
    currencyCode: "EUR",
    vatRate: 22.0,
    vatRefund: 0.22,
    minimumAmount: 70.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품, 구매일로부터 3개월 이내에 EU를 떠날 때 개인 수하물로 반출되는 상품",
    refundMethod: "공항 환급 또는 시내 환급소",
    refundPlace: "로마, 밀라노 공항 등",
    notes: "세관 도장 필수, 영수증 및 상품 제시"
)

let greecePolicy = VATRefundPolicy(
    country: "그리스",
    currencyCode: "EUR",
    vatRate: 24.0,
    vatRefund: 0.24,
    minimumAmount: 50.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품, 구매일로부터 3개월 이내에 EU를 떠날 때 개인 수하물로 반출되는 상품",
    refundMethod: "공항 환급",
    refundPlace: "아테네 공항 등",
    notes: "세관 도장 필수, 영수증 및 상품 제시"
)

let swedenPolicy = VATRefundPolicy(
    country: "스웨덴",
    currencyCode: "SEK",
    vatRate: 25.0,
    vatRefund: 0.25,
    minimumAmount: 200.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품, 구매일로부터 3개월 이내에 EU를 떠날 때 개인 수하물로 반출되는 상품",
    refundMethod: "공항 환급",
    refundPlace: "스톡홀름 아를란다 공항 등",
    notes: "세관 도장 필수, 영수증 및 상품 제시"
)

let denmarkPolicy = VATRefundPolicy(
    country: "덴마크",
    currencyCode: "DKK",
    vatRate: 25.0,
    vatRefund: 0.25,
    minimumAmount: 300.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품, 구매일로부터 3개월 이내에 EU를 떠날 때 개인 수하물로 반출되는 상품",
    refundMethod: "공항 환급",
    refundPlace: "코펜하겐 공항 등",
    notes: "세관 도장 필수, 영수증 및 상품 제시"
)

let norwayPolicy = VATRefundPolicy(
    country: "노르웨이",
    currencyCode: "NOK",
    vatRate: 25.0,
    vatRefund: 0.25,
    minimumAmount: 315.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "노르웨이, 스웨덴, 핀란드, 덴마크 외 국가 거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품, 구매일로부터 1개월 이내에 노르웨이를 떠날 때 개인 수하물로 반출되는 상품",
    refundMethod: "공항 환급",
    refundPlace: "오슬로 공항 등",
    notes: "세관 도장 필수, 영수증 및 상품 제시"
)

let finlandPolicy = VATRefundPolicy(
    country: "핀란드",
    currencyCode: "EUR",
    vatRate: 24.0,
    vatRefund: 0.24,
    minimumAmount: 40.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품, 구매일로부터 3개월 이내에 EU를 떠날 때 개인 수하물로 반출되는 상품",
    refundMethod: "공항 환급",
    refundPlace: "헬싱키 공항 등",
    notes: "세관 도장 필수, 영수증 및 상품 제시"
)

let mexicoPolicy = VATRefundPolicy(
    country: "멕시코",
    currencyCode: "MXN",
    vatRate: 16.0,
    vatRefund: 0.16,
    minimumAmount: 0.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "멕시코에 180일 미만 체류한 외국인",
    eligibleItems: "개인 사용을 위한 미사용 상품, 구매일로부터 3개월 이내",
    refundMethod: "불명",
    refundPlace: "불명",
    notes: "제공된 정보 불완전"
)

let brazilPolicy = VATRefundPolicy(
    country: "브라질",
    currencyCode: "BRL",
    vatRate: 18.0,
    vatRefund: 0.18,
    minimumAmount: 0.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비거주 외국인 관광객",
    eligibleItems: "개인 사용을 위한 상품 (음식, 호텔, 레스토랑 소비 제외)",
    refundMethod: "공항 환급 또는 지정된 환급소",
    refundPlace: "리우데자네이루 공항 등",
    notes: "2025년부터 리우데자네이루 주에서 시범 운영 중, 향후 전국 확대 예정; VAT는 주별로 상이 (예: 리우데자네이루 18%)"
)

let polandPolicy = VATRefundPolicy(
    country: "폴란드",
    currencyCode: "PLN",
    vatRate: 23.0,
    vatRefund: 0.23,
    minimumAmount: 200.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품",
    refundMethod: "공항 환급 또는 시내 환급소",
    refundPlace: "바르샤바 공항 등",
    notes: "구매일로부터 3개월 이내에 물품을 EU 외 지역으로 반출, 세관 도장 필수"
)

let romaniaPolicy = VATRefundPolicy(
    country: "루마니아",
    currencyCode: "RON",
    vatRate: 19.0,
    vatRefund: 0.19,
    minimumAmount: 250.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "비EU 거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품",
    refundMethod: "공항 환급 또는 시내 환급소",
    refundPlace: "부쿠레슈티 공항 등",
    notes: "구매일로부터 90일 이내에 물품을 EU 외 지역으로 반출, 세관 도장 필수"
)

let icelandPolicy = VATRefundPolicy(
    country: "아이슬란드",
    currencyCode: "ISK",
    vatRate: 24.0,
    vatRefund: 0.24,
    minimumAmount: 12000.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "아이슬란드 비거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품",
    refundMethod: "공항 환급",
    refundPlace: "케플라비크 공항 등",
    notes: "구매일로부터 3개월 이내에 물품을 반출, 세관 도장 필수"
)

let russiaPolicy = VATRefundPolicy(
    country: "러시아",
    currencyCode: "RUB",
    vatRate: 20.0,
    vatRefund: 0.2,
    minimumAmount: 10000.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "EAEU 외 국가 거주자",
    eligibleItems: "의류, 전자제품, 보석 등 (주류, 담배 제외)",
    refundMethod: "공항 환급",
    refundPlace: "모스크바 도모데도보 공항 등",
    notes: "구매일로부터 3개월 이내에 물품을 반출, 세관 도장 필수"
)

let israelPolicy = VATRefundPolicy(
    country: "이스라엘",
    currencyCode: "ILS",
    vatRate: 17.0,
    vatRefund: 0.17,
    minimumAmount: 400.0,
    refundRateDescription: "VAT 환급",
    eligibleBuyers: "이스라엘 비거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품",
    refundMethod: "공항 환급",
    refundPlace: "벤구리온 공항 등",
    notes: "구매일로부터 3개월 이내에 물품을 반출, 세관 도장 필수"
)

let indiaPolicy = VATRefundPolicy(
    country: "인도",
    currencyCode: "INR",
    vatRate: 18.0,
    vatRefund: 0.18,
    minimumAmount: 0.0,
    refundRateDescription: "GST 환급",
    eligibleBuyers: "인도 비거주자",
    eligibleItems: "개인 사용을 위한 미사용 상품",
    refundMethod: "공항 환급",
    refundPlace: "델리 인디라 간디 국제공항 등",
    notes: "GST 환급 제도 시범 운영 중, 전국적으로 시행되지 않음"
)

struct RefundCondition {
    static let flagToPolicyMap: [String: VATRefundPolicy] = [
        "🇯🇵": japanPolicy,
        "🇰🇷": koreaPolicy,
        "🇹🇭": thailandPolicy,
        "🇲🇾": malaysiaPolicy,
        "🇸🇬": singaporePolicy,
        "🇮🇩": indonesiaPolicy,
        "🇦🇺": australiaPolicy,
        "🇹🇷": turkeyPolicy,
        "🇿🇦": southAfricaPolicy,
        "🇨🇿": czechRepublicPolicy,
        "🇭🇺": hungaryPolicy,
        "🇧🇬": bulgariaPolicy,
        "🇨🇭": switzerlandPolicy,
        "🇩🇪": germanyPolicy,
        "🇳🇱": netherlandsPolicy,
        "🇧🇪": belgiumPolicy,
        "🇫🇷": francePolicy,
        "🇪🇸": spainPolicy,
        "🇵🇹": portugalPolicy,
        "🇮🇪": irelandPolicy,
        "🇦🇹": austriaPolicy,
        "🇭🇷": croatiaPolicy,
        "🇮🇹": italyPolicy,
        "🇬🇷": greecePolicy,
        "🇸🇪": swedenPolicy,
        "🇩🇰": denmarkPolicy,
        "🇳🇴": norwayPolicy,
        "🇫🇮": finlandPolicy,
        "🇲🇽": mexicoPolicy,
        "🇧🇷": brazilPolicy,
        "🇵🇱": polandPolicy,
        "🇷🇴": romaniaPolicy,
        "🇮🇸": icelandPolicy,
        "🇷🇺": russiaPolicy,
        "🇮🇱": israelPolicy,
        "🇮🇳": indiaPolicy
    ]
}
