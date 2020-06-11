//
//  TodayWeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Admin on 2020/06/10.
//  Copyright © 2020 Admin. All rights reserved.
//

import XCTest

@testable import WeatherApp


class TodayWeatherViewModelTests: XCTestCase {
    let jsonDecoder = JSONDecoder()
    
    func testForCurrentWeatherSuccess() {
        do {
            let todayWeather = try jsonDecoder.decode(TodayWeather.self, from: Data.init())
            let serviceHandler = MockServiceHandler()
            serviceHandler.daillyResult = .success(payload:todayWeather)
            
            let viewModel = TodayWeatherViewModel(serviceHandler: serviceHandler)
            viewModel.getCurrentWeatherData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
            
            XCTAssertNotNil(viewModel.currentTemp, "Current temperature not found")
            XCTAssertNotNil(viewModel.description, "Description not found")
            XCTAssertNotNil(viewModel.minTemp, "Minimum temperature not found")
            XCTAssertNotNil(viewModel.maxTemp,"Maximum temperature not found")
        }
        catch {}
    }
    
    func testForCurrentWeatherFailure() {
        let serviceHandler = MockServiceHandler()
        serviceHandler.daillyResult = .failure(nil)
        let viewModel = TodayWeatherViewModel(serviceHandler: serviceHandler)
        viewModel.getCurrentWeatherData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
        viewModel.onShowError = { error in
            XCTAssertNotNil(error)
        }
    }
    
    private final class MockServiceHandler: ServiceHandler {
        var daillyResult: ServiceHandler.TodayResult?
        override func getTodayWeather(params: [(String, String)], completion: @escaping ServiceHandler.TodayResultCompletion) {
            completion(daillyResult!)
        }
    }
}
