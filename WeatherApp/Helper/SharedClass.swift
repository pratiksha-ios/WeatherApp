//
//  SharedClass.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import JGProgressHUD

class SharedClass: NSObject {
    static let sharedInstance = SharedClass()
    let loader = JGProgressHUD(style: .extraLight)
    var dateMiliSeconds : Double = 0
    func showLoader(_ strTitle:String = "Loading") {
        DispatchQueue.main.async {
            if var topController = UIApplication.shared.delegate?.window??.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                self.loader.textLabel.text = strTitle
                self.loader.show(in: topController.view)
            }
        }
    }
    
    func dismissLoader() {
        DispatchQueue.main.async {
            self.loader.dismiss(animated: true)
        }
    }
    
    func getWeatherThemeColor(name:String) -> UIColor {
        if name == "Clouds" {
            return WeatherType.Coludy.color
        }
        else if name == "Rain" {
            return WeatherType.Rainy.color
        }
        else if name == "Thunderstorm" {
            return WeatherType.Thunderstorm.color
        }
        else if name == "Sunny" {
            return WeatherType.Sunny.color
        }
        return WeatherType.Default.color
    }
    
    func getWeatherIcon(name:String) -> UIImage {
        if name == "Clouds" {
            return WeatherType.Coludy.icon
        }
        else if name == "Rain" {
            return WeatherType.Rainy.icon
        }
        else if name == "Thunderstorm" {
            return WeatherType.Thunderstorm.icon
        }
        else if name == "Sunny" {
            return WeatherType.Sunny.icon
        }
        return WeatherType.Default.icon
    }
    
    func getWeatherImage(name:String) -> UIImage {
        if name == "Clouds" {
            return WeatherType.Coludy.image
        }
        else if name == "Rain" {
            return WeatherType.Rainy.image
        }
        else if name == "Thunderstorm" {
            return WeatherType.Thunderstorm.image
        }
        else if name == "Sunny" {
            return WeatherType.Sunny.image
        }
        return WeatherType.Default.image
    }
    
    
    
}
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String,font: UIFont!) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font ?? .none!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String,font: UIFont!) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font ?? .none!]
        let normal = NSMutableAttributedString(string:text, attributes: attrs)
        append(normal)
        return self
    }
}

enum WeatherType {
    case Sunny
    case Coludy
    case Rainy
    case Thunderstorm
    case Default
}

extension WeatherType {
    var color: UIColor {
        get {
            switch self {
            case .Sunny:
                return UIColor.init(red: 71.0/255.0, green: 171.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            case .Coludy:
                return UIColor.init(red: 84.0/255.0, green: 113.0/255.0, blue: 122.0/255.0, alpha: 1.0)
            case .Rainy, .Thunderstorm:
                return UIColor.init(red: 87.0/255.0, green: 87.0/255.0, blue: 93.0/255.0, alpha: 1.0)
            case .Default:
                return UIColor.init(red: 71.0/255.0, green: 171.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            }
        }
    }
    
    var icon: UIImage {
        get {
            switch self {
            case .Sunny:
                return UIImage.init(named: "clear")!
            case .Coludy:
                return UIImage.init(named: "partlysunny")!
            case .Rainy, .Thunderstorm:
                return UIImage.init(named: "rain")!
            case .Default:
                return UIImage.init(named: "clear")!
            }
        }
    }
    
    var image: UIImage {
        get {
            switch self {
            case .Sunny:
                return UIImage.init(named: "forest_sunny")!
            case .Coludy:
                return UIImage.init(named: "forest_cloudy")!
            case .Rainy, .Thunderstorm:
                return UIImage.init(named: "forest_rainy")!
            case .Default:
                return UIImage.init(named: "forest_sunny")!
            }
        }
    }
}
extension Notification.Name {
    static let getWeatherData = Notification.Name("getWeatherData")
}
