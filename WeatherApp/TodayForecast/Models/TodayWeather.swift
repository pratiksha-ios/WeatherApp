//
//  TodayWeather.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import RealmSwift

class TodayWeather: Object, Codable {
    dynamic var weather : [Weather]?
    dynamic var main : Main?
    dynamic var id : Double?

    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case main = "main"
        case id = "id"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        main = try values.decodeIfPresent(Main.self, forKey: .main)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
        id = try values.decodeIfPresent(Double.self, forKey: .id) ?? 0
    }
}
