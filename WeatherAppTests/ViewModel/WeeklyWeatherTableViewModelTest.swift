//
//  WeeklyWeatherTableViewModelTest.swift
//  WeatherAppTests
//
//  Created by Admin on 2020/06/10.
//  Copyright © 2020 Admin. All rights reserved.
//

import XCTest

@testable import WeatherApp

class WeeklyWeatherTableViewModelTest: XCTestCase {
    let jsonDecoder = JSONDecoder()
    
    func testForNormalCells() {
        do {
            let weeklyWeather = try jsonDecoder.decode(WeeklyWeather.self, from: Data.init())
            let serviceHandler = MockServiceHandler()
            serviceHandler.weeklyeResult = .success(payload:weeklyWeather)
            let viewModel = WeeklyWeatherViewModel(serviceHandler: serviceHandler)
            viewModel.getWeeklyData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
            guard case .some(.normal(_)) = viewModel.weeklyDatacells.value.first else{
                XCTFail()
                return
            }
        }
        catch {}
    }
    
    func testEmptyCells() {
        do {
            let weeklyWeather = try jsonDecoder.decode(WeeklyWeather.self, from: Data.init())
            let serviceHandler = MockServiceHandler()
            serviceHandler.weeklyeResult = .success(payload:weeklyWeather)
            let viewModel = WeeklyWeatherViewModel(serviceHandler: serviceHandler)
            viewModel.getWeeklyData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
            guard case .some(.empty) = viewModel.weeklyDatacells.value.first else {
                XCTFail()
                return
            }
        }
        catch {}
    }
    
    func testErrorCells() {
        let serviceHandler = MockServiceHandler()
        serviceHandler.weeklyeResult = .failure(ServiceHandler.WeekyDataFailureReason.notFound)
        let viewModel = WeeklyWeatherViewModel(serviceHandler: serviceHandler)
        viewModel.getWeeklyData(params: [("lat", "\(45.00)"), ("lon", "\(35.87)")])
        guard case .some(.error) = viewModel.weeklyDatacells.value.first else {
            XCTFail()
            return
        }
    }
    
    private final class MockServiceHandler: ServiceHandler {
        var weeklyeResult: ServiceHandler.WeeklyResult?
        override func getWeeklyDataOfFiveDays(params: [(String, String)], completion: @escaping ServiceHandler.WeeklyResultCompletion) {
            completion(weeklyeResult!)
        }
    }
}
