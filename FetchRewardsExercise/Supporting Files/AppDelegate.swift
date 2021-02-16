//
//  AppDelegate.swift
//  FetchRewardsExercise
//
//  Created by Sajan Shrestha on 2/15/21.
//

import UIKit
import SVProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var window: UIWindow? = {
        return UIApplication.shared.windows.first
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureSVProgressIndicator()

        return true
    }
    
    private func configureSVProgressIndicator() {
        SVProgressHUD.setRingRadius(1.0)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.3076365292, green: 0.3655088544, blue: 0.4252530336, alpha: 1))
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

