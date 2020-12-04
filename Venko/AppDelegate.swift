//
//  AppDelegate.swift
//  Venko
//
//  Created by Matias Glessi on 18/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import UIKit
import SDWebImageWebPCoder
import IQKeyboardManagerSwift
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureFirebase()
        configureWebPCoder()
        configureIQKeyboardManager()
        
        return true
    }
    
    private func configureWebPCoder() {
        let WebPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(WebPCoder)
    }
    
    private func configureIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        
        IQKeyboardManager.shared.toolbarManageBehaviour = .byPosition
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "OK"
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.toolbarTintColor = isDarkMode() ? .white : .black
    }
    
    private func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func isDarkMode() -> Bool {
        if #available(iOS 12.0, *) {
            return UIScreen.main.traitCollection.userInterfaceStyle == .dark
        } else {
           return false
        }
    }


}


