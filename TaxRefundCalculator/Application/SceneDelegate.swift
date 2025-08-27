//
//  SceneDelegate.swift
//  TaxRefundCalculator
//
//  Created by 이재건 on 4/25/25.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        //UIWindowScene 객체 생성.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        // 다크모드 설정
        let saveUserDefaults = SaveUserDefaults()
        let isDarkMode = saveUserDefaults.getDarkModeEnabled() // 다크모드
        window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light // 다크모드
        
        // 앱 실행 시 파이어베이스 데이터 날짜 싱크 맞추기
        let _ = ExchangeSyncManager.shared.performInitialSyncIfNeeded()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: {
                // 동기화 완료 → rootVC 교체
                if saveUserDefaults.getIsDoneFirstStep() == true {
                    window.rootViewController = TabBarController()
                } else {
                    let firebaseExchangeService = FirebaseExchangeService()
                    let startPageVM = StartPageVM(firebaseService: firebaseExchangeService)
                    window.rootViewController = StartPageVC(viewModel: startPageVM)
                }
                window.makeKeyAndVisible()
                self.window = window
            }, onFailure: { error in
                // 동기화 실패, 에러 -> 기본 화면
                if saveUserDefaults.getIsDoneFirstStep() == true {
                    window.rootViewController = TabBarController()
                } else {
                    let firebaseExchangeService = FirebaseExchangeService()
                    let startPageVM = StartPageVM(firebaseService: firebaseExchangeService)
                    window.rootViewController = StartPageVC(viewModel: startPageVM)
                }
                window.makeKeyAndVisible()
                self.window = window
            })
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}
