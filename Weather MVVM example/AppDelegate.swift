//
//  AppDelegate.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 23.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainScreenViewModel: MainScreenViewModel!
    let weatherManager: WeatherManager = WeatherManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.mainScreenViewModel = MainScreenViewModel(weatherManager: weatherManager)
        if let mainScreenViewController = self.window?.rootViewController as? MainScreenViewController {
            mainScreenViewController.viewModel = self.mainScreenViewModel
        }
        return true
    }



}

