//
//  MainScreenViewModel.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 23.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//
import CoreLocation
import CoreData
import SwiftyJSON
class MainScreenViewModel {
    weak var weatherManager: WeatherManager!
    private var cellsArray: [CityUITableViewCellViewModel]! = [CityUITableViewCellViewModel]()
    private var weatherArray: [WeatherModel]! = [WeatherModel]()
    private var detailsViewModel: DetailsScreenViewModel!
    private var cities: [City]

    func updateWeathers (completion: (() -> Void)? = nil) {
        var newCellsArray: [CityUITableViewCellViewModel] = [CityUITableViewCellViewModel]()
        var newWeatherArray: [WeatherModel] = [WeatherModel]()
        if self.cities.count != 0 {
            let dispatchGroup = DispatchGroup()
            for cityName in self.cities.map({$0.cityName}) {
                dispatchGroup.enter()
                self.weatherManager.getWeatherByCityName(cityName: cityName, completion: { (weatherModel) in
                    newWeatherArray.append(weatherModel)
                    newCellsArray.append(CityUITableViewCellViewModel(weather: weatherModel))
                    dispatchGroup.leave()
                })
                
            }
            dispatchGroup.notify(queue: DispatchQueue.main) {
                self.cellsArray = newCellsArray
                self.weatherArray = newWeatherArray
                self.cellsArray.sort{ (self.cities.map({$0.cityName}).index(of: $0.cityTitle)!) < (self.cities.map({$0.cityName}).index(of: $1.cityTitle)!) }
                self.weatherArray.sort{ (self.cities.map({$0.cityName}).index(of: $0.city)!) < (self.cities.map({$0.cityName}).index(of: $1.city)!) }
                completion?()
            }
        }
        else {
            completion?()
        }
    }
    
    
    func addWeatherByCityName(cityName: String, failure: ((String)->Void)? = nil, completion: (() -> Void)? = nil) {
        self.weatherManager.getWeatherByCityName(cityName: cityName,failure: failure, completion: { (weatherModel) in
            self.weatherArray.append(weatherModel)
            self.cellsArray.append(CityUITableViewCellViewModel(weather: weatherModel))
            let city = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.createItem(City.self)
            city.cityName = cityName
            self.cities.append(city)
            completion?()
        })
    }
    
    
    func addWeatherByLocation(coordinate: CLLocationCoordinate2D, failure: ((String)->Void)? = nil, completion: (() -> Void)? = nil) {
        self.weatherManager.getWeatherByLocation(coordinate: coordinate,failure: failure, completion: { (weatherModel) in
            self.weatherArray.append(weatherModel)
            self.cellsArray.append(CityUITableViewCellViewModel(weather: weatherModel))
            let city = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.createItem(City.self)
            city.cityName = weatherModel.city
            self.cities.append(city)
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

    required init(weatherManager: WeatherManager, cities: [City]) {
        self.weatherManager = weatherManager
        self.cities = cities
    }
}
