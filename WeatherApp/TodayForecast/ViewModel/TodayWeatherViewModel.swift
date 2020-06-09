//
//  TodayWeatherViewModel.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class TodayWeatherViewModel  {
    public static let baseTemperature = 273.15
    private let serviceHandler: ServiceHandler
    private let showLoadingHud: Bindable = Bindable(false)
    
    let description = Bindable(String.init())
    var minTemp = Bindable(String.init())
    var currentTemp = Bindable(String.init())
    var maxTemp = Bindable(String.init())
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    var todayWeather: TodayWeather? = nil
    
    init(serviceHandler: ServiceHandler = ServiceHandler()) {
        self.serviceHandler = serviceHandler
    }
    // current weather of city with lat anad lon
    func getCurrentWeatherData(params: [(String, String)]){
        showLoadingHud.value = true
        serviceHandler.getTodayWeather(params:params){ [weak self] result in
            guard let strongSelf = self  else { return }
            strongSelf.showLoadingHud.value = false
            switch result {
            case .success(let data):
                self?.handleTodayWeatherResponse(data: data)
            case .failure(let error):
                let okAlert = SingleButtonAlert(
                    title: error?.getErrorMessage() ?? "Could not connect to server. Check your network and try again later.",
                    message: "Failed to update information.",
                    action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") })
                )
                self?.onShowError?(okAlert)
            }
        }
    }
    
    private func handleTodayWeatherResponse(data: TodayWeather) {
        if let temp = data.main?.temp {
            self.currentTemp.value = String(Int(round(temp - TodayWeatherViewModel.baseTemperature))) + "° Current"
        }
        if let description = data.weather.first?.main {
            self.description.value = description
        }
        if let temp_min = data.main?.temp_min {
            self.minTemp.value = String(Int(round(temp_min - TodayWeatherViewModel.baseTemperature))) + "°   Min"
        }
        if let temp_max = data.main?.temp_max {
            self.maxTemp.value = String(Int(round(temp_max - TodayWeatherViewModel.baseTemperature))) + "°   Max"
        }
        SharedClass.sharedInstance.dateMiliSeconds = data.dt 
        self.todayWeather = data
    }
    
    func setTodayWeatherAsFavourite() {
        if let todayWeather = self.todayWeather {
            RealmManager.sharedInstance.add([todayWeather])
        }
    }
    
    func getTodayWeatherDataFromLocalDB() {
        let todayRecords = RealmManager.sharedInstance.retrieveAllDataForObject(TodayWeather.self).map{$0 as! TodayWeather}
        if let todayRecord = todayRecords.max(by: { Double($0.dt) < Double($1.dt) }) {
            self.handleTodayWeatherResponse(data: todayRecord) }
    }


}

// failur message
fileprivate extension ServiceHandler.TodayDataFailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .invalidkey:
            return "Your key is invalid"
        case .notFound:
            return "Api key is missing"
        }
    }
}

