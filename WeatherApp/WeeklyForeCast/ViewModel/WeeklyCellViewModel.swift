//
//  WeeklyCellViewModel.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol WeeklyCellViewModel {
    var tempStr:String{ get }
    var dayStr:String { get }
}

extension Forecast: WeeklyCellViewModel{
    var tempStr: String {
        return String(format: "%.2f", self.main?.temp ?? "")
    }
    var dayStr : String{
        if ((self.weather.count) > 0), let weather = self.weather.first, let dayString = weather.main {
            return dayString
        }
        return ""
    }
}
