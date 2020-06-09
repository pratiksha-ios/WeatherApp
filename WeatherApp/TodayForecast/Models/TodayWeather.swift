//
//  TodayWeather.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import RealmSwift

@objcMembers class TodayWeather: Object, Codable {
    dynamic var main : Main? = nil
    dynamic var dt : Double = 0
    let weather = RealmSwift.List<Weather>()

    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case main = "main"
        case dt = "dt"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        main = try values.decodeIfPresent(Main.self, forKey: .main)
        let weathers = try values.decode([Weather].self, forKey: .weather)
        weather.append(objectsIn: weathers)
        dt = try values.decodeIfPresent(Double.self, forKey: .dt) ?? 0
    }
}
