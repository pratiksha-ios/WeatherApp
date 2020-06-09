//
//  WeeklyWeatherViewModel.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class WeeklyWeatherViewModel {
    
    enum WeeklyDataTableViewCellType {
        case normal(cellValue:(day: String, forecasts: ForecastModel))
        case error(message: String)
        case empty
    }
    fileprivate let formatter = DateFormatter()
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)
    
    let weeklyDatacells = Bindable([WeeklyDataTableViewCellType]())
    let navTitle:Bindable = Bindable(String.init())
    let serviceHandler: ServiceHandler
    var weeklyWeather : WeeklyWeather? = nil
    
    init(serviceHandler: ServiceHandler = ServiceHandler()) {
        self.serviceHandler = serviceHandler
    }
    
    func getWeeklyData(params: [(String, String)]) {
        self.showLoadingHud.value = true
        self.serviceHandler.getWeeklyDataOfFiveDays(params:params){ [weak self] result in
            self?.showLoadingHud.value = false
            switch result {
            case .success(let data):
                self?.handleWeeklyWeatherResponse(data: data)
            case .failure(let error):
                self?.weeklyDatacells.value = [.error(message: error?.getErrorMessage() ?? "Loading failed, check network connection")]
            }
        }
    }
    
    func getWeeklyDataFromLocalDB() {
        let weeklyRecords = RealmManager.sharedInstance.retrieveAllDataForObject(WeeklyWeather.self).map{$0 as! WeeklyWeather}
        if let weeklyRecord = weeklyRecords.max(by: { Double($0.dt) < Double($1.dt) }) {
            self.handleWeeklyWeatherResponse(data: weeklyRecord) }
    }
    
    private func handleWeeklyWeatherResponse(data: WeeklyWeather) {
        self.navTitle.value = data.city?.name ?? ""
        guard  data.list.count > 0 else {
            self.weeklyDatacells.value = [.empty]
            return
        }
        let cellData =  self.cells(from: data)
        self.weeklyWeather = data
        self.weeklyDatacells.value = cellData.compactMap{.normal(cellValue: $0) }
    }
    func setWeeklyWeatherAsFavourite() {
        if let weeklyWeather = self.weeklyWeather {
            weeklyWeather.dt = SharedClass.sharedInstance.dateMiliSeconds
            RealmManager.sharedInstance.add([weeklyWeather])
        }
    }
        
    private func cells(from weather: WeeklyWeather)-> [(day: String, forecasts: ForecastModel)]{
        
        let forecasts = weather.list
        let allTimestamps = forecasts.map { (obj) -> String in
            let date = NSDate(timeIntervalSince1970:obj.dt)
            return self.dateTimestampFromDate(date: date)
        }
        var uniqueDayTimestamps = allTimestamps
            .map(dayTimestampFromDateTimstamp)
            .uniqueElements
        let currentDay = dateTimestampFromDate(date: NSDate()).components(separatedBy: " ").first
        uniqueDayTimestamps.removeAll{$0 == currentDay}
        
        let forecastsForDays = uniqueDayTimestamps.compactMap { day -> [Forecast] in
            return forecasts.filter { forecast in
                let date = NSDate(timeIntervalSince1970:forecast.dt)
                let forecastTimestamp = dateTimestampFromDate(date: date)
                let dayOfForecast = dayTimestampFromDateTimstamp(timestamp: forecastTimestamp)
                return dayOfForecast == day
            }
        }
        
        let forcastModel = forecastsForDays.compactMap { (aryForecasts) -> ForecastModel? in
            let forcast = aryForecasts.max(by: { (a, b) -> Bool in
                return Int(round(a.main?.temp ?? 0)) < Int(round(b.main?.temp ?? 0))
            })!
            return forecastModel(from: forcast)
        }
        
        let days = forecasts.map { (obj) -> String in
            let date = NSDate(timeIntervalSince1970:obj.dt)
            return date.dayOfWeek(formatter: self.formatter)
        }
       
        let dayStrings = days.unique().filter{obj in obj != NSDate().dayOfWeek()!}
        
        //Combine those two Items into an Array of tuples
        return Array(zip(dayStrings, forcastModel))
    }
    
    private func forecastModel(from forecast: Forecast)-> ForecastModel {
        if let temprature = forecast.main?.temp_max {
            let dt = forecast.dt
            let date = NSDate(timeIntervalSince1970:dt)
            return ForecastModel(
                time: "\(date.formattedTime(formatter: formatter))",
                description: "\(forecast.weather.first?.main ?? "")",
                temp: "\(Int(round(temprature) - TodayWeatherViewModel.baseTemperature))°")
        }
        return ForecastModel(time: "", description: "", temp: "")
    }
    
    private func dateTimestampFromDate(date: NSDate)-> String {
        formatter.dateFormat = "YYMMdd HHmm"
        return formatter.string(from: date as Date)
    }
    
    private func dayTimestampFromDateTimstamp(timestamp: String)-> String {
        return String(describing: timestamp.split(separator: " ")[0])
    }
    
    func checkCurrentLocationMarkAsFavourite(completion: @escaping(Bool) -> Void) {
        if let location = LocationService.sharedInstance.currentLocation {
            let weeklyRecords = RealmManager.sharedInstance.retrieveAllDataForObject(WeeklyWeather.self).map{$0 as! WeeklyWeather}
            if weeklyRecords.firstIndex(where: {(String(format: "%.1f", $0.city?.coord?.lat ?? 0).contains(String(format: "%.1f", location.coordinate.latitude)) && String(format: "%.1f", $0.city?.coord?.lon ?? 0).contains(String(format: "%.1f", location.coordinate.longitude)) )}) != nil {
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
}

private extension ServiceHandler.WeekyDataFailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .invalidkey:
            return "Your key is not valid"
        case .notFound:
            return "Failed to add friend. Please try again."
        }
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
