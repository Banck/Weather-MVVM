//
//  MainScreenViewModel.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 23.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//
import CoreLocation
import SwiftyJSON
class MainScreenViewModel {
    weak var weatherManager: WeatherManager!
    private var cellsArray = [CityUITableViewCellViewModel]()
    private var weatherArray: [WeatherModel]! = [WeatherModel]()
    private var detailsViewModel: DetailsScreenViewModel!
    
    func addWeatherByCityName(cityName: String, failure: ((String)->Void)? = nil, completion: (() -> Void)? = nil) {
        self.weatherManager.getWeatherByCityName(cityName: cityName,failure: failure, completion: { (weatherModel) in
            self.weatherArray.append(weatherModel)
            self.cellsArray.append(CityUITableViewCellViewModel(weather: weatherModel))
            completion?()
        })
    }
    
    
    func addWeatherByLocation(coordinate: CLLocationCoordinate2D, failure: ((String)->Void)? = nil, completion: (() -> Void)? = nil) {
        self.weatherManager.getWeatherByLocation(coordinate: coordinate,failure: failure, completion: { (weatherModel) in
            self.weatherArray.append(weatherModel)
            self.cellsArray.append(CityUITableViewCellViewModel(weather: weatherModel))
            completion?()
        })
    }
    
    func numberOfCities() -> Int {
        return cellsArray.count
    }
    func cellViewModel(index: Int) -> CityUITableViewCellViewModel? {
        guard cellsArray.count > index else {
            return nil
        }
        return cellsArray[index]
    }
    
    func detailsViewModel(index: Int) -> DetailsScreenViewModel {
        self.detailsViewModel = DetailsScreenViewModel(weather: weatherArray[index])
        return self.detailsViewModel
    }

    required init(weatherManager: WeatherManager) {
        self.weatherManager = weatherManager
    }
}
