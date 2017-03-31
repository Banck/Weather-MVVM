//
//  CityUITableViewCell.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 24.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//

import UIKit

class CityUITableViewCell: UITableViewCell {

    @IBOutlet var precipitationImageView: UIImageView!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    weak var viewModel: CityUITableViewCellViewModel!{
        didSet {
            self.cityNameLabel.text = viewModel.cityTitle
            self.temperatureLabel.text = viewModel.temperature
            self.precipitationImageView.image = UIImage(data: viewModel.precipitationData as Data)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
