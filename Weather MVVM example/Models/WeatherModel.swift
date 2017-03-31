//
//  WeatherModel.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 23.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//
import SwiftyJSON
struct WeatherModel {
    var city: String!
    var temperature: Float!
    var wind: WindDirection!
    var precipitation: Precipitation!
    
    init(json: JSON) {
        var precipitation: Precipitation!
        switch json["weather"][0]["main"] {
        case "Clouds":
            precipitation = Precipitation.Cloudly
            break
        case "Rain":
            precipitation = Precipitation.Rainy
            break
        case "Sunny":
            precipitation = Precipitation.Sunny
            break
        case "Clear":
            precipitation = Precipitation.Sunny
            break
        case "Fog":
            precipitation = Precipitation.Foggy
            break
        case "Haze":
            precipitation = Precipitation.Foggy
            break
        default:
            precipitation = Precipitation.Cloudly
        }
        var windDirection: WindDirection
        switch json["wind"]["deg"].doubleValue {
        case 0..<22.5:
            windDirection = .Northerly
            break
        case 22.5..<67.5:
            windDirection = .NorthEasterly
            break
        case 67.5..<122.5:
            windDirection = .Easterly
            break
        case 122.5..<157.5:
            windDirection = .SouthEasterly
            break
        case 157.5..<202.5:
            windDirection = .Southerly
            break
        case 202.5..<247.5:
            windDirection = .SouthWesterly
            break
        case 247.5..<292.5:
            windDirection = .Westerly
            break
        default:
            windDirection = .Northerly
            break
       
        }
        self.city = json["name"].string
        self.temperature = json["main"]["temp"].float
        self.wind = windDirection
        self.precipitation = precipitation
    }
    
}
