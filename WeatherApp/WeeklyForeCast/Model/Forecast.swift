//
//  Forecast.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Forecast: Object, Codable {
    dynamic var dt : Double = 0
    dynamic var main : Main? = nil
    dynamic var clouds : Clouds? = nil
    dynamic var wind : Wind? = nil
    dynamic var sys : Sys? = nil
    dynamic var dt_txt : String? = ""
    let weather = RealmSwift.List<Weather>()

    
    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case main = "main"
        case weather = "weather"
        case clouds = "clouds"
        case wind = "wind"
        case sys = "sys"
        case dt_txt = "dt_txt"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dt = try values.decodeIfPresent(Double.self, forKey: .dt) ?? 0
        main = try values.decodeIfPresent(Main.self, forKey: .main)
        let weathers = try values.decode([Weather].self, forKey: .weather)
        weather.append(objectsIn: weathers)
        clouds = try values.decodeIfPresent(Clouds.self, forKey: .clouds)
        wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
        sys = try values.decodeIfPresent(Sys.self, forKey: .sys)
        dt_txt = try values.decodeIfPresent(String.self, forKey: .dt_txt)
    }
}
