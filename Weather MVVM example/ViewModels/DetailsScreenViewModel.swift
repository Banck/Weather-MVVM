//
//  DetailsScreenViewModel.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 28.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//

import Foundation
class DetailsScreenViewModel {
    let weather: WeatherModel
    
    var cityName: String!
    var precipitationImageData: NSData!
    var windDirectionImageData: NSData!
    var temperature: String!

    required init(weather: WeatherModel) {
        self.weather = weather
        
        self.cityName = weather.city
        
        switch weather.precipitation! {
        case .Cloudly:
            self.precipitationImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "cloudly", ofType: "png")!)
            break
        case .Rainy:
            self.precipitationImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "rainy", ofType: "png")!)
            break
        case .Stormly:
            self.precipitationImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "stormly", ofType: "png")!)
            break
        case .Sunny:
            self.precipitationImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "sunny", ofType: "png")!)
            break
        case .Foggy:
            precipitationImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "foggy", ofType: "png")!)
            break
        }
        
        switch weather.wind! {
        case .Easterly:
            self.windDirectionImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "East", ofType: "png")!)
            break
        case .NorthEasterly:
            self.windDirectionImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "North East", ofType: "png")!)
            break
        case .Northerly:
            self.windDirectionImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "North", ofType: "png")!)
            break
        case .NorthWesterly:
            self.windDirectionImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "North West", ofType: "png")!)
            break
        case .SouthEasterly:
            self.windDirectionImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "South East", ofType: "png")!)
            break
        case .Southerly:
            self.windDirectionImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "South", ofType: "png")!)
            break
        case .SouthWesterly:
            self.windDirectionImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "South West", ofType: "png")!)
            break
        case .Westerly:
            self.windDirectionImageData = NSData(contentsOfFile: Bundle.main.path(forResource: "West", ofType: "png")!)
            break
        }
        
        self.temperature = String(format: "%.0f%@", (weather.temperature! - 273) ,"\u{00B0}C")

        
    }
}
