//
//  WeatherManager.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 28.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation
class WeatherManager {
    fileprivate let baseURL = "http://api.openweathermap.org/data/2.5/weather"
    
    func getWeatherByCityName(cityName: String!, failure: ((String) -> Void)? = nil ,completion: ((WeatherModel) -> Void)? = nil ) -> Void {
        let parameters: [String: Any] = ["q" : cityName,
                                         "appid" : (Bundle.main.object(forInfoDictionaryKey: "WeatherApiKey")!)]
        self.getWeather(parameters: parameters, failure: failure, completion: completion)
    }
    
    func getWeatherByLocation(coordinate: CLLocationCoordinate2D!, failure: ((String) -> Void)? = nil ,completion: ((WeatherModel) -> Void)? = nil ) -> Void {
        let parameters: [String: Any] = ["lat" : coordinate.latitude,
                                         "lon" : coordinate.longitude,
                                         "appid" : (Bundle.main.object(forInfoDictionaryKey: "WeatherApiKey")!)]
        self.getWeather(parameters: parameters, failure: failure, completion: completion)
    }
    
    private func getWeather(parameters: [String : Any],  failure: ((String) -> Void)? = nil ,completion: ((WeatherModel) -> Void)? = nil) {
        RequestManager.sharedInstance.request(url: baseURL, parameters: parameters, failure: { (error) in
            failure?(error.localizedDescription)
        }, completion:  { (result) in
            if JSON.parse(result)["name"].string == nil {
                failure?("Something went wrong. Please, try again later")
            } else {
                let weatherModel: WeatherModel = WeatherModel(json: JSON.parse(result))
                completion?(weatherModel)
            }
        })
    }
    
}
