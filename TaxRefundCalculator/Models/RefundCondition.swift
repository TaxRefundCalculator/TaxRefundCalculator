//
//  RefundCondition.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 5/15/25.
//

import Foundation

// MARK: - 환급 정책 목록 구조체
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

// MARK: - 환급 정책 목록
let koreaPolicy = VATRefundPolicy(
    country: "South Korea",
    currencyCode: "KRW",
    vatRate: 10.0,
    vatRefund: 0.07,
    minimumAmount: 15000.0,
    refundRateDescription: "Up to 7% of purchase amount",
    eligibleBuyers: "Foreign tourists staying less than 6 months, overseas Koreans staying less than 3 months and living abroad for over 2 years",
    eligibleItems: "Taxable goods in unopened and unused condition, goods exported within 3 months of purchase",
    refundMethod: "Immediate refund, downtown refund center, airport refund",
    refundPlace: "Refund counters or kiosks at Incheon International Airport and major airports, downtown refund centers in Seoul and other major cities",
    notes: "Customs stamp on purchased goods required."
)

let japanPolicy = VATRefundPolicy(
    country: "Japan",
    currencyCode: "JPY",
    vatRate: 10.0,
    vatRefund: 0.1,
    minimumAmount: 5000.0,
    refundRateDescription: "Tax-free at the time of purchase",
    eligibleBuyers: "Foreign tourists",
    eligibleItems: "General goods",
    refundMethod: "Tax-free (immediate at purchase)",
    refundPlace: "Tax-free shops",
    notes: "Refund system to be introduced from 2026 (currently tax-free)."
)

let thailandPolicy = VATRefundPolicy(
    country: "Thailand",
    currencyCode: "THB",
    vatRate: 7.0,
    vatRefund: 0.07,
    minimumAmount: 2000.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Foreign tourists",
    eligibleItems: "Goods purchased at approved shops, goods exported within 60 days",
    refundMethod: "Airport refund",
    refundPlace: "VAT refund counter at departure hall",
    notes: "Purchase at approved shops, depart within 60 days."
)

let malaysiaPolicy = VATRefundPolicy(
    country: "Malaysia",
    currencyCode: "MYR",
    vatRate: 6.0,
    vatRefund: 0.06,
    minimumAmount: 300.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Foreign tourists",
    eligibleItems: "Goods purchased at approved shops",
    refundMethod: "Airport refund",
    refundPlace: "Airport VAT refund counter",
    notes: "Only available at shops approved by the Tourism Tax Office."
)

let singaporePolicy = VATRefundPolicy(
    country: "Singapore",
    currencyCode: "SGD",
    vatRate: 9.0,
    vatRefund: 0.09,
    minimumAmount: 100.0,
    refundRateDescription: "GST refund",
    eligibleBuyers: "Foreign tourists",
    eligibleItems: "Goods exported when leaving Singapore, some items excluded",
    refundMethod: "Electronic refund (eTRS)",
    refundPlace: "Airport eTRS kiosk",
    notes: "Passport registration required, some items excluded."
)

let indonesiaPolicy = VATRefundPolicy(
    country: "Indonesia",
    currencyCode: "IDR",
    vatRate: 11.0,
    vatRefund: 0.11,
    minimumAmount: 500000.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Foreign tourists (excluding crew, etc.)",
    eligibleItems: "Goods exported abroad",
    refundMethod: "Airport refund",
    refundPlace: "VAT refund office",
    notes: "Crew, etc. are not eligible for refunds."
)

let australiaPolicy = VATRefundPolicy(
    country: "Australia",
    currencyCode: "AUD",
    vatRate: 10.0,
    vatRefund: 0.1,
    minimumAmount: 300.0,
    refundRateDescription: "GST refund",
    eligibleBuyers: "Foreign tourists",
    eligibleItems: "Goods purchased within 30 days before departure",
    refundMethod: "Airport refund (TRS)",
    refundPlace: "TRS counter at departure hall",
    notes: "Purchase within 30 days before departure, recommend arriving at least 90 minutes early."
)

let turkeyPolicy = VATRefundPolicy(
    country: "Turkey",
    currencyCode: "TRY",
    vatRate: 18.0,
    vatRefund: 0.18,
    minimumAmount: 100.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Foreign tourists",
    eligibleItems: "Approved items",
    refundMethod: "Airport refund",
    refundPlace: "Refund counter after customs verification",
    notes: "Only for approved items."
)

let southAfricaPolicy = VATRefundPolicy(
    country: "South Africa",
    currencyCode: "ZAR",
    vatRate: 15.0,
    vatRefund: 0.15,
    minimumAmount: 250.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Foreign tourists",
    eligibleItems: "Goods exported abroad",
    refundMethod: "Airport refund",
    refundPlace: "VAT refund office",
    notes: "Customs verification required."
)

let czechRepublicPolicy = VATRefundPolicy(
    country: "Czech Republic",
    currencyCode: "CZK",
    vatRate: 21.0,
    vatRefund: 0.21,
    minimumAmount: 2001.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Foreign tourists",
    eligibleItems: "Goods exported within 90 days",
    refundMethod: "Airport refund",
    refundPlace: "Refund counter at departure hall",
    notes: "Customs stamp required, depart within 90 days."
)

let hungaryPolicy = VATRefundPolicy(
    country: "Hungary",
    currencyCode: "HUF",
    vatRate: 27.0,
    vatRefund: 0.27,
    minimumAmount: 54001.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Foreign tourists",
    eligibleItems: "Goods exported abroad",
    refundMethod: "Airport refund",
    refundPlace: "Customs and refund office",
    notes: "Receipt required."
)

let bulgariaPolicy = VATRefundPolicy(
    country: "Bulgaria",
    currencyCode: "BGN",
    vatRate: 20.0,
    vatRefund: 0.2,
    minimumAmount: 125.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Foreign tourists",
    eligibleItems: "Goods exported abroad",
    refundMethod: "Airport refund",
    refundPlace: "Refund counter",
    notes: "Customs verification required."
)

let switzerlandPolicy = VATRefundPolicy(
    country: "Switzerland",
    currencyCode: "CHF",
    vatRate: 7.7,
    vatRefund: 0.077,
    minimumAmount: 300.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-residents",
    eligibleItems: "Goods exported abroad",
    refundMethod: "Airport refund",
    refundPlace: "Partner shops or refund offices",
    notes: "Only for non-EU nationals."
)

let germanyPolicy = VATRefundPolicy(
    country: "Germany",
    currencyCode: "EUR",
    vatRate: 19.0,
    vatRefund: 0.19,
    minimumAmount: 50.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Goods exported outside the EU",
    refundMethod: "Airport refund",
    refundPlace: "Global Blue / Planet refund office",
    notes: "Customs stamp required."
)

let netherlandsPolicy = VATRefundPolicy(
    country: "Netherlands",
    currencyCode: "EUR",
    vatRate: 21.0,
    vatRefund: 0.21,
    minimumAmount: 50.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Goods exported outside the EU",
    refundMethod: "Airport refund",
    refundPlace: "Refund counter after customs stamp",
    notes: "Difficult to get a refund on the day of departure."
)

let belgiumPolicy = VATRefundPolicy(
    country: "Belgium",
    currencyCode: "EUR",
    vatRate: 21.0,
    vatRefund: 0.21,
    minimumAmount: 125.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Goods purchased at approved shops",
    refundMethod: "Airport refund",
    refundPlace: "Refund office",
    notes: "Only at approved shops, customs verification required."
)

let francePolicy = VATRefundPolicy(
    country: "France",
    currencyCode: "EUR",
    vatRate: 20.0,
    vatRefund: 0.20,
    minimumAmount: 100.01,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Goods exported outside the EU",
    refundMethod: "PABLO electronic certification or refund office",
    refundPlace: "Airport",
    notes: "Approx. 12% fee deducted."
)

let spainPolicy = VATRefundPolicy(
    country: "Spain",
    currencyCode: "EUR",
    vatRate: 21.0,
    vatRefund: 0.21,
    minimumAmount: 90.15,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Goods exported outside the EU",
    refundMethod: "DIVA kiosk",
    refundPlace: "Airport",
    notes: "Electronic certification required."
)

let portugalPolicy = VATRefundPolicy(
    country: "Portugal",
    currencyCode: "EUR",
    vatRate: 23.0,
    vatRefund: 0.23,
    minimumAmount: 61.50,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Goods exported outside the EU",
    refundMethod: "Airport refund",
    refundPlace: "Refund counter",
    notes: "Depart within 90 days."
)

let irelandPolicy = VATRefundPolicy(
    country: "Ireland",
    currencyCode: "EUR",
    vatRate: 23.0,
    vatRefund: 0.23,
    minimumAmount: 75.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Goods for personal use, exported as personal baggage within 3 months of purchase upon leaving the EU",
    refundMethod: "Retail shop or refund agency",
    refundPlace: "Dublin, Shannon airports, etc.",
    notes: "Only some shops participate; check before purchase."
)

let austriaPolicy = VATRefundPolicy(
    country: "Austria",
    currencyCode: "EUR",
    vatRate: 20.0,
    vatRefund: 0.20,
    minimumAmount: 75.01,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Unused goods for personal use, exported as personal baggage within 3 months of purchase upon leaving the EU",
    refundMethod: "Airport refund or downtown refund office",
    refundPlace: "Vienna airport, etc.",
    notes: "Customs stamp required; present receipt and goods."
)

let croatiaPolicy = VATRefundPolicy(
    country: "Croatia",
    currencyCode: "EUR",
    vatRate: 25.0,
    vatRefund: 0.25,
    minimumAmount: 100.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Unused goods for personal use, exported as personal baggage within 3 months of purchase upon leaving the EU",
    refundMethod: "Airport refund",
    refundPlace: "Zagreb airport, etc.",
    notes: "Customs stamp required; present receipt and goods."
)

let italyPolicy = VATRefundPolicy(
    country: "Italy",
    currencyCode: "EUR",
    vatRate: 22.0,
    vatRefund: 0.22,
    minimumAmount: 70.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Unused goods for personal use, exported as personal baggage within 3 months of purchase upon leaving the EU",
    refundMethod: "Airport refund or downtown refund office",
    refundPlace: "Rome, Milan airports, etc.",
    notes: "Customs stamp required; present receipt and goods."
)

let greecePolicy = VATRefundPolicy(
    country: "Greece",
    currencyCode: "EUR",
    vatRate: 24.0,
    vatRefund: 0.24,
    minimumAmount: 50.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Unused goods for personal use, exported as personal baggage within 3 months of purchase upon leaving the EU",
    refundMethod: "Airport refund",
    refundPlace: "Athens airport, etc.",
    notes: "Customs stamp required; present receipt and goods."
)

let swedenPolicy = VATRefundPolicy(
    country: "Sweden",
    currencyCode: "SEK",
    vatRate: 25.0,
    vatRefund: 0.25,
    minimumAmount: 200.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Unused goods for personal use, exported as personal baggage within 3 months of purchase upon leaving the EU",
    refundMethod: "Airport refund",
    refundPlace: "Stockholm Arlanda airport, etc.",
    notes: "Customs stamp required; present receipt and goods."
)

let denmarkPolicy = VATRefundPolicy(
    country: "Denmark",
    currencyCode: "DKK",
    vatRate: 25.0,
    vatRefund: 0.25,
    minimumAmount: 300.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Unused goods for personal use, exported as personal baggage within 3 months of purchase upon leaving the EU",
    refundMethod: "Airport refund",
    refundPlace: "Copenhagen airport, etc.",
    notes: "Customs stamp required; present receipt and goods."
)

let norwayPolicy = VATRefundPolicy(
    country: "Norway",
    currencyCode: "NOK",
    vatRate: 25.0,
    vatRefund: 0.25,
    minimumAmount: 315.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Residents of countries other than Norway, Sweden, Finland, Denmark",
    eligibleItems: "Unused goods for personal use, exported as personal baggage within 1 month of purchase upon leaving Norway",
    refundMethod: "Airport refund",
    refundPlace: "Oslo airport, etc.",
    notes: "Customs stamp required; present receipt and goods."
)

let finlandPolicy = VATRefundPolicy(
    country: "Finland",
    currencyCode: "EUR",
    vatRate: 24.0,
    vatRefund: 0.24,
    minimumAmount: 40.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Unused goods for personal use, exported as personal baggage within 3 months of purchase upon leaving the EU",
    refundMethod: "Airport refund",
    refundPlace: "Helsinki airport, etc.",
    notes: "Customs stamp required; present receipt and goods."
)

let mexicoPolicy = VATRefundPolicy(
    country: "Mexico",
    currencyCode: "MXN",
    vatRate: 16.0,
    vatRefund: 0.16,
    minimumAmount: 0.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Foreigners staying in Mexico less than 180 days",
    eligibleItems: "Unused goods for personal use, within 3 months of purchase",
    refundMethod: "Unknown",
    refundPlace: "Unknown",
    notes: "Incomplete information provided."
)

let brazilPolicy = VATRefundPolicy(
    country: "Brazil",
    currencyCode: "BRL",
    vatRate: 18.0,
    vatRefund: 0.18,
    minimumAmount: 0.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-resident foreign tourists",
    eligibleItems: "Goods for personal use (excluding food, hotels, restaurant consumption)",
    refundMethod: "Airport refund or designated refund office",
    refundPlace: "Rio de Janeiro airport, etc.",
    notes: "Pilot program in Rio de Janeiro state from 2025, nationwide expansion planned; VAT rate varies by state (e.g., 18% in Rio de Janeiro)"
)

let polandPolicy = VATRefundPolicy(
    country: "Poland",
    currencyCode: "PLN",
    vatRate: 23.0,
    vatRefund: 0.23,
    minimumAmount: 200.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Unused goods for personal use",
    refundMethod: "Airport refund or downtown refund office",
    refundPlace: "Warsaw airport, etc.",
    notes: "Goods must be exported outside the EU within 3 months of purchase; customs stamp required"
)

let romaniaPolicy = VATRefundPolicy(
    country: "Romania",
    currencyCode: "RON",
    vatRate: 19.0,
    vatRefund: 0.19,
    minimumAmount: 250.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-EU residents",
    eligibleItems: "Unused goods for personal use",
    refundMethod: "Airport refund or downtown refund office",
    refundPlace: "Bucharest airport, etc.",
    notes: "Goods must be exported outside the EU within 90 days of purchase; customs stamp required"
)

let icelandPolicy = VATRefundPolicy(
    country: "Iceland",
    currencyCode: "ISK",
    vatRate: 24.0,
    vatRefund: 0.24,
    minimumAmount: 12000.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-residents of Iceland",
    eligibleItems: "Unused goods for personal use",
    refundMethod: "Airport refund",
    refundPlace: "Keflavik airport, etc.",
    notes: "Goods must be exported within 3 months of purchase; customs stamp required"
)

let russiaPolicy = VATRefundPolicy(
    country: "Russia",
    currencyCode: "RUB",
    vatRate: 20.0,
    vatRefund: 0.2,
    minimumAmount: 10000.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Residents of countries outside the EAEU",
    eligibleItems: "Clothing, electronics, jewelry, etc. (excluding alcohol, tobacco)",
    refundMethod: "Airport refund",
    refundPlace: "Moscow Domodedovo airport, etc.",
    notes: "Goods must be exported within 3 months of purchase; customs stamp required"
)

let israelPolicy = VATRefundPolicy(
    country: "Israel",
    currencyCode: "ILS",
    vatRate: 17.0,
    vatRefund: 0.17,
    minimumAmount: 400.0,
    refundRateDescription: "VAT refund",
    eligibleBuyers: "Non-residents of Israel",
    eligibleItems: "Unused goods for personal use",
    refundMethod: "Airport refund",
    refundPlace: "Ben Gurion airport, etc.",
    notes: "Goods must be exported within 3 months of purchase; customs stamp required"
)

let indiaPolicy = VATRefundPolicy(
    country: "India",
    currencyCode: "INR",
    vatRate: 18.0,
    vatRefund: 0.18,
    minimumAmount: 0.0,
    refundRateDescription: "GST refund",
    eligibleBuyers: "Non-residents of India",
    eligibleItems: "Unused goods for personal use",
    refundMethod: "Airport refund",
    refundPlace: "Delhi Indira Gandhi International Airport, etc.",
    notes: "GST refund system is in pilot operation, not implemented nationwide"
)

// MARK: - 국기를 트리거로 정책 매칭
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
