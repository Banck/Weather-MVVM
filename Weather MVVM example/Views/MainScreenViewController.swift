//
//  MainScreenViewController.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 23.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView
class MainScreenViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    let activityData = ActivityData(type: .ballRotateChase)
    let locationManager = CLLocationManager()
    weak var viewModel: MainScreenViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CityUITableViewCell", bundle: nil), forCellReuseIdentifier: "CityCell")
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    // MARK: --TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCities()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: CityUITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cityCell") as? CityUITableViewCell
        if cell == nil {
            cell = UINib(nibName: "CityUITableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as? CityUITableViewCell
        }
        cell!.viewModel = self.viewModel.cellViewModel(index: indexPath.row)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetails", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: --Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let locValue: CLLocationCoordinate2D = manager.location?.coordinate {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
            
            self.viewModel.addWeatherByLocation(coordinate: locValue, failure: { (errorString) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.showAlert(message: errorString, cancel: "Ok")
                
            }, completion: {
                self.tableView.reloadData()
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            })
        }
        
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func addNewCityButtonWasPressed(sender: UIButton)
    {
        self.showAlert(title: "Add new city", message: "Please, write city here", cancel: "Cancel", buttons: ["Add"], textField: true) { (alertController, alertAction) in
            if alertAction.title == "Add" && alertController.textFields![0].text != "" {
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                self.viewModel.addWeatherByCityName(cityName: alertController.textFields![0].text!, failure: { (errorString) in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.showAlert(message: errorString, cancel: "Ok")
                }, completion: {
                    self.tableView.reloadData()
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                })
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let detailsController = segue.destination as? DetailsViewController, let index = sender as? Int {
            detailsController.viewModel = self.viewModel.detailsViewModel(index: index)
        }

    }

}

