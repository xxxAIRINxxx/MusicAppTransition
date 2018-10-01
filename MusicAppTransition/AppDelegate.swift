//
//  AppDelegate.swift
//  MusicAppTransition
//
//  Created by xxxAIRINxxx on 2018/08/01.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import UIKit
import Movin

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Movin.isDebugPrintEnabled = true
        return true
    }
}
