//
//  RequestManager.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 24.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
class RequestManager: NSObject
{
    static let sharedInstance = RequestManager()
    
    func request(url: String!, parameters: [String : Any]? = nil, method: Alamofire.HTTPMethod = .get, failure: ((Error) -> Void)? = nil, completion: ((String) -> Void)? = nil) {
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding()).responseString { (response) in
            switch response.result {
            case .success(let value):
                debugPrint("JSON: \(value)")
                completion?(value)
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /*
    func getWeatherByCityName(cityName: String!, failure: ((Error) -> Void)? = nil, completion: ((String) -> Void)? = nil)
    {
        Alamofire.request("\(self.baseURL)q=\(cityName!)&appid=\(Bundle.main.object(forInfoDictionaryKey: "WeatherApiKey")!)".addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!).responseString { (response) in
            switch response.result {
            case .success(let value):
                debugPrint("JSON: \(value)")
                completion?(value)
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    func getWeatherByLocation(coordinate: CLLocationCoordinate2D!, failure: ((Error) -> Void)? = nil, completion: ((String) -> Void)? = nil)
    {
        Alamofire.request("\(self.baseURL)lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(Bundle.main.object(forInfoDictionaryKey: "WeatherApiKey")!)".addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!).responseString { (response) in
            switch response.result {
            case .success(let value):
                debugPrint("JSON: \(value)")
                completion?(value)
            case .failure(let error):
                failure?(error)
            }
        }
    }
 */

}
