//
//  DetailsViewController.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 28.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var precipitationImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var windDirectionImageView: UIImageView!

    weak var viewModel: DetailsScreenViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityNameLabel.text = self.viewModel.cityName
        self.precipitationImageView.image = UIImage(data: self.viewModel.precipitationImageData as Data)
        self.temperatureLabel.text = self.viewModel.temperature
        self.windDirectionImageView.image = UIImage(data: self.viewModel.windDirectionImageData as Data)
        // Do any additional setup after loading the view.
    }

    @IBAction func closeButtonWasPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    

}
