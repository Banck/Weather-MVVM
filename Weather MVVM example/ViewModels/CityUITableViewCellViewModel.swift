 //
//  CityUITableViewCellViewModel.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 24.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//

import Foundation
class CityUITableViewCellViewModel {
    var cityTitle: String!
    var temperature: String!
    var precipitationData: NSData!
    
    required init(weather: WeatherModel) {
        cityTitle = weather.city
        temperature = String(format: "%.0f%@", (weather.temperature! - 273) ,"\u{00B0}C")// "\(weather.temperature!) \u{00B0}C"
        switch weather.precipitation! {
        case .Cloudly:
            precipitationData = NSData(contentsOfFile: Bundle.main.path(forResource: "cloudly", ofType: "png")!)
            break
        case .Rainy:
            precipitationData = NSData(contentsOfFile: Bundle.main.path(forResource: "rainy", ofType: "png")!)
            break
        case .Stormly:
            precipitationData = NSData(contentsOfFile: Bundle.main.path(forResource: "stormly", ofType: "png")!)
            break
        case .Sunny:
            precipitationData = NSData(contentsOfFile: Bundle.main.path(forResource: "sunny", ofType: "png")!)
            break
        case .Foggy:
            precipitationData = NSData(contentsOfFile: Bundle.main.path(forResource: "foggy", ofType: "png")!)
            break
        }
        
    }
}
