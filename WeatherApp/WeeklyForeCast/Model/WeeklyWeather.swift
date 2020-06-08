//
//  WeeklyWeather.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class WeeklyWeather: Object, Codable {
    dynamic var cod : String? = nil
    dynamic var message : Double?
    dynamic var cnt : Int?
    dynamic var list : [Forecast]?
    dynamic var city : City?
    dynamic var id : Double?
    
    enum CodingKeys: String, CodingKey {
        case cod = "cod"
        case message = "message"
        case cnt = "cnt"
        case list = "list"
        case city = "city"
        case id = "id"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cod = try values.decodeIfPresent(String.self, forKey: .cod)
        message = try values.decodeIfPresent(Double.self, forKey: .message)
        cnt = try values.decodeIfPresent(Int.self, forKey: .cnt)
        list = try values.decodeIfPresent([Forecast].self, forKey: .list)
        city = try values.decodeIfPresent(City.self, forKey: .city)
        id = try values.decodeIfPresent(Double.self, forKey: .id) ?? 0
    }
    
}
