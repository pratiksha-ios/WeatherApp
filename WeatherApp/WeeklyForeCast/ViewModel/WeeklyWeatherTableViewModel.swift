//
//  WeeklyWeatherTableViewModel.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class WeeklyWeatherTableViewModel {
    
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
    let appServerClient: AppServerClient
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    func getWeeklyData(params: [(String, String)]) {
        showLoadingHud.value = true
        appServerClient.getWeeklyDataOfFiveDays(params:params){ [weak self] result in
            self?.showLoadingHud.value = false
            switch result {
            case .success(let data):
                self?.navTitle.value = data.city?.name ?? ""
                guard  data.list!.count > 0, let cellData =  self?.cells(from: data) else {
                    self?.weeklyDatacells.value = [.empty]
                    return
                }
                self?.weeklyDatacells.value = cellData.compactMap{.normal(cellValue: $0) }
                
            case .failure(let error):
                self?.weeklyDatacells.value = [.error(message: error?.getErrorMessage() ?? "Loading failed, check network connection")]
            }
        }
    }
    
    private func cells(from weather: WeeklyWeather)-> [(day: String, forecasts: ForecastModel)]{
        
        guard let forecasts = weather.list else {
            return Array()
        }
        let allTimestamps = forecasts.map { (obj) -> String in
            let date = NSDate(timeIntervalSince1970:obj.dt!)
            return dateTimestampFromDate(date: date)
        }
        var uniqueDayTimestamps = allTimestamps
            .map(dayTimestampFromDateTimstamp)
            .uniqueElements
        let currentDay = dateTimestampFromDate(date: NSDate()).components(separatedBy: " ").first
        uniqueDayTimestamps.removeAll{$0 == currentDay}
        
        let forecastsForDays = uniqueDayTimestamps.compactMap { day -> [Forecast] in
            return forecasts.filter { forecast in
                let date = NSDate(timeIntervalSince1970:forecast.dt!)
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
            let date = NSDate(timeIntervalSince1970:obj.dt!)
            return date.dayOfWeek(formatter: formatter)
        }
        let dayStrings = days
            .uniqueElements.filter{obj in obj != NSDate().dayOfWeek()!}
        
        //Combine those two Items into an Array of tuples
        return Array(zip(dayStrings, forcastModel))
    }
    
    private func forecastModel(from forecast: Forecast)-> ForecastModel {
        if let dt = forecast.dt, let temprature = forecast.main?.temp_max {
            let date = NSDate(timeIntervalSince1970:dt)
            return ForecastModel(
                time: "\(date.formattedTime(formatter: formatter))",
                description: "\(forecast.weather?.first?.main ?? "")",
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
}

private extension AppServerClient.WeekyDataFailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .invalidkey:
            return "Your key is not valid"
        case .notFound:
            return "Failed to add friend. Please try again."
        }
    }
}
