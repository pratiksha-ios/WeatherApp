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
    private let appServerClient: AppServerClient
    private let showLoadingHud: Bindable = Bindable(false)
    
    let description = Bindable(String.init())
    var minTemp = Bindable(String.init())
    var currentTemp = Bindable(String.init())
    var maxTemp = Bindable(String.init())
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    // current weather of city with lat anad lon
    func getCurrentWeatherData(params: [(String, String)]){
        showLoadingHud.value = true
        appServerClient.getTodayWeather(params:params){ [weak self] result in
            guard let strongSelf = self  else { return }
            strongSelf.showLoadingHud.value = false
            switch result {
            case .success(let data):
                if let temp = data.main?.temp {
                    strongSelf.currentTemp.value = String(Int(round(temp - TodayWeatherViewModel.baseTemperature))) + "° Current"
                }
                if let description = data.weather?.first?.main {
                    strongSelf.description.value = description
                }
                if let temp_min = data.main?.temp_min {
                    strongSelf.minTemp.value = String(Int(round(temp_min - TodayWeatherViewModel.baseTemperature))) + "°   Min"
                }
                if let temp_max = data.main?.temp_max {
                    strongSelf.maxTemp.value = String(Int(round(temp_max - TodayWeatherViewModel.baseTemperature))) + "°   Max"
                }
                
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
}

// failur message
fileprivate extension AppServerClient.TodayDataFailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .invalidkey:
            return "Your key is invalid"
        case .notFound:
            return "Api key is missing"
        }
    }
}

