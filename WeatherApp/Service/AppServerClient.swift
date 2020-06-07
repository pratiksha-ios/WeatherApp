//
//  AppServerClient.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

class AppServerClient {
    
    static func setUrlPathComponent(url:URL,params: [(String, String)])-> URLComponents{
        var queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
        let keyQueryItem = URLQueryItem(name: "APPID", value: Constants.APPID)
        queryItems.append(keyQueryItem)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = queryItems
        return urlComponents
    }
    
    private struct Constants {
        static let APPID = "76ecc7bc578cff08af7b8ed12b79fd88"
        static let baseURL = "https://api.openweathermap.org/data/2.5/"
    }
    enum ResourcePath: String {
        case Forecast = "forecast"
        case CurrentWeather = "weather"
        var path: String {
            return Constants.baseURL + rawValue
        }
    }
    
    // Weekly Weather
    enum WeekyDataFailureReason: Int, Error {
        case invalidkey = 401
        case notFound = 404
    }
    
    typealias WeeklyResult = Result<WeeklyWeather, WeekyDataFailureReason>
    typealias WeeklyResultCompletion = (_ result: WeeklyResult) -> Void
    
    func getWeeklyDataOfFiveDays(params: [(String, String)], completion: @escaping WeeklyResultCompletion){
        
        let urlComponent = AppServerClient.setUrlPathComponent(url: URL(string:ResourcePath.Forecast.path)!, params: params)
        guard let urlString = urlComponent.url?.absoluteString else {
            return
        }
        Alamofire.request(urlString, method:.get, parameters:nil, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 300)
            .responseJSON{ response in
                switch response.result {
                case .success:
                    let jsonDecoder = JSONDecoder()
                    do {
                        let weeklyWeather = try jsonDecoder.decode(WeeklyWeather.self, from: response.data!)
                        completion(.success(payload:weeklyWeather))
                    }
                    catch { completion(.failure(nil)) }
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = WeekyDataFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
    
    
    // Current Weather
    enum TodayDataFailureReason: Int, Error {
        case invalidkey = 401
        case notFound = 404
    }
    
    typealias TodayResult = Result<TodayWeather, TodayDataFailureReason>
    typealias TodayResultCompletion = (_ result: TodayResult) -> Void
    
    func getTodayWeather(params: [(String, String)], completion: @escaping TodayResultCompletion){
        
        let urlComponent = AppServerClient.setUrlPathComponent(url:URL(string:ResourcePath.CurrentWeather.path)!, params: params)
        print((urlComponent.url?.absoluteString)!)
        Alamofire.request((urlComponent.url?.absoluteString)!, method:.get, parameters:nil, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ..< 300)
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    let jsonDecoder = JSONDecoder()
                    do {
                        let currentWeather = try jsonDecoder.decode(TodayWeather.self, from: response.data!)
                        completion(.success(payload:currentWeather))
                    }
                    catch { completion(.failure(nil)) }
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = TodayDataFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
}
