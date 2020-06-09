//
//  WeeklyWeather.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class WeeklyWeather: Object, Codable {
    dynamic var cod : String? = ""
    dynamic var message : Double = 0
    dynamic var cnt : Int = 0
    dynamic var city : City? = nil
    dynamic var dt : Double = 0
    let list = RealmSwift.List<Forecast>()

    enum CodingKeys: String, CodingKey {
        case cod = "cod"
        case message = "message"
        case cnt = "cnt"
        case list = "list"
        case city = "city"
        case dt = "dt"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cod = try values.decodeIfPresent(String.self, forKey: .cod)
        message = try values.decodeIfPresent(Double.self, forKey: .message) ?? 0
        cnt = try values.decodeIfPresent(Int.self, forKey: .cnt) ?? 0
        let lists = try values.decode([Forecast].self, forKey: .list)
        list.append(objectsIn: lists)
        city = try values.decodeIfPresent(City.self, forKey: .city)
        dt = try values.decodeIfPresent(Double.self, forKey: .dt) ?? 0
    }
    
}
