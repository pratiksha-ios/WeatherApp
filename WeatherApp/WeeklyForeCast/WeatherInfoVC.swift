//
//  WeatherInfoVC.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreLocation

struct ForecastModel {
    let time: String
    let description: String
    let temp: String
}

class WeatherInfoVC: UIViewController {
    @IBOutlet weak var imgThemeWeather: UIImageView!
    @IBOutlet weak var lblCurrentTempDesc: UILabel!
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    let todayViewModel: TodayWeatherViewModel = TodayWeatherViewModel()
    let weeklyViewModel: WeeklyWeatherTableViewModel = WeeklyWeatherTableViewModel()
    
    // Viewcontroller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getWeatherData), name: .getWeatherData, object: nil)
        bindWeeklyViewModel()
        bindTodayViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWeatherData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .getWeatherData, object: nil)
    }
    
    //get weather data
    @objc func getWeatherData() {
        delay(delay: 0.2) {
            if Reachability.isConnectedToNetwork(){
                if let location = LocationService.sharedInstance.currentLocation {
                    self.updateWeatherData(location: location)
                }
            }
        }
    }
    
    // checking location and connection
    private func checkLocationAndConnection(){
        if !Reachability.isConnectedToNetwork(){
            showInternetAlert()
        }
        if !LocationService.isLocationServiceEnabled(){
            showLocationAlert()
        }
    }
    
    // bind weekly view model
    private func bindWeeklyViewModel() {
        weeklyViewModel.weeklyDatacells.bindAndFire() { [weak self] _ in
            self?.tableView?.reloadData()
        }
        weeklyViewModel.onShowError = { [weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
        weeklyViewModel.showLoadingHud.bind() { visible in
            visible ? SharedClass.sharedInstance.showLoader() : SharedClass.sharedInstance.dismissLoader()
        }
    }
    
    // bind  today view model
    private func bindTodayViewModel(){
        todayViewModel.minTemp.bind{ [weak self] minTemp in
            self?.lblMinTemp.text = minTemp
        }
        todayViewModel.currentTemp.bind{ [weak self] currentTemp in
            self?.lblCurrentTemp.text = currentTemp
        }
        todayViewModel.maxTemp.bind{ [weak self] maxTemp in
            self?.lblMaxTemp.text = maxTemp
        }
        todayViewModel.description.bind{ [weak self] description in
            self?.view.backgroundColor = SharedClass.sharedInstance.getWeatherThemeColor(name: description)
            self?.imgThemeWeather.image = SharedClass.sharedInstance.getWeatherImage(name: description)
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal((self?.lblCurrentTemp.text?.components(separatedBy: " ").first)!,font: UIFont(name: "Verdana-Bold", size: 34)!)
                .bold(" \(description)",font: UIFont(name: "Verdana", size: 34)!)
            
            self?.lblCurrentTempDesc.attributedText = formattedString
        }
        
        todayViewModel.onShowError = { [weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
    }
    
    // Api hit and update weather data
    private func updateWeatherData(location:CLLocation){
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        DispatchQueue.once {
            weeklyViewModel.getWeeklyData(params: [("lat", "\(lat)"), ("lon", "\(lon)")])
            todayViewModel.getCurrentWeatherData(params: [("lat", "\(lat)"), ("lon", "\(lon)")])
        }
    }
    
    private func getErrorCell(message : String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.isUserInteractionEnabled = false
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.text = message
        return cell
    }
}

// tableview datasource
extension WeatherInfoVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyViewModel.weeklyDatacells.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch weeklyViewModel.weeklyDatacells.value[indexPath.row]{
        case .normal(let cellValue):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell") as? WeeklyTableViewCell else {
                return UITableViewCell()
            }
            let forecast = cellValue.forecasts as ForecastModel
            let icon = SharedClass.sharedInstance.getWeatherIcon(name: forecast.description)
            cell.configureCell(cellValue.day, icon: icon, temp: forecast.temp)
            return cell
            
        case .error(let message):
            return self.getErrorCell(message: message)
        case .empty:
            return self.getErrorCell(message: "No data available")
        }
    }
    
}
