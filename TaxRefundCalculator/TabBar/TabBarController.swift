//
//  TabBarController.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/30/25.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let calculateVC = CalculateVC()
        let savedVM = SavedVM()
        let savedVC = SavedVC(viewModel: savedVM)

        let firebaseExchangeService = FirebaseExchangeService()
        let exchangeVM = ExchangeVM(firebaseService: firebaseExchangeService)
        let exchangeVC = ExchangeVC(viewModel: exchangeVM)
        
        SettingVM.shared.firebaseService = firebaseExchangeService

        let settingVC = SettingVC()

        calculateVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Calculate", comment: ""), image: UIImage(systemName: "plus.slash.minus"), tag: 0)
        savedVC.tabBarItem = UITabBarItem(title: NSLocalizedString("History", comment: ""), image: UIImage(systemName: "clock"), tag: 1)
        exchangeVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Exchange Rate", comment: ""), image: UIImage(systemName: "chart.bar.xaxis"), tag: 2)
        settingVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Settings", comment: ""), image: UIImage(systemName: "gearshape"), tag: 3)

        viewControllers = [calculateVC, savedVC, exchangeVC, settingVC]

        tabBar.tintColor = .tabActive // 선택된 항목 색상
        tabBar.unselectedItemTintColor = .tabInactive // 선택되지 않은 항목 색상
        tabBar.backgroundColor = .bgPrimary
    }
}
