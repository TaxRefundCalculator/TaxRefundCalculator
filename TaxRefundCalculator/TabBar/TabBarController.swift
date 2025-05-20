//
//  TabBarController.swift
//  TaxRefundCalculator
//
//  Created by YoungJin on 4/30/25.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let calculateVC = CalculateVC()
        let savedVC = SavedVC()
        let exchangeVC = ExchangeVC()
        let settingVC = SettingVC()

        calculateVC.tabBarItem = UITabBarItem(title: "계산", image: UIImage(systemName: "plus.slash.minus"), tag: 0)
        savedVC.tabBarItem = UITabBarItem(title: "기록", image: UIImage(systemName: "clock"), tag: 1)
        exchangeVC.tabBarItem = UITabBarItem(title: "환율", image: UIImage(systemName: "chart.bar.xaxis"), tag: 2)
        settingVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), tag: 3)

        viewControllers = [calculateVC, savedVC, exchangeVC, settingVC]

        tabBar.tintColor = .tabActive // 선택된 항목 색상
        tabBar.unselectedItemTintColor = .tabInactive // 선택되지 않은 항목 색상
        tabBar.backgroundColor = .bgPrimary
    }
}
