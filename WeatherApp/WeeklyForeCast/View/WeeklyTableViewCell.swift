//
//  WeeklyTableViewCell.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    
    func configureCell(_ day:String?, icon:UIImage?, temp:String?){
        self.lblDay.text = day
        self.imgWeatherIcon.image = icon
        self.lblTemperature.text = temp
    }
    
    var viewModel: WeeklyCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        if let temp = viewModel?.tempStr{
            lblTemperature.text = temp
        }
        if let day = viewModel?.dayStr {
            lblDay.text = day
        }
    }
    
}
