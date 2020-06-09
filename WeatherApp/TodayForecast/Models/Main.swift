//
//  Main.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Main: Object, Codable {
    dynamic var temp : Double = 0
    dynamic var temp_min : Double = 0
    dynamic var temp_max : Double = 0
    dynamic var pressure : Double = 0
    dynamic var sea_level : Double = 0
    dynamic var grnd_level : Double = 0
    dynamic var humidity : Int = 0
    dynamic var temp_kf : Double = 0
    
    enum CodingKeys: String, CodingKey {
        
        case temp = "temp"
        case temp_min = "temp_min"
        case temp_max = "temp_max"
        case pressure = "pressure"
        case sea_level = "sea_level"
        case grnd_level = "grnd_level"
        case humidity = "humidity"
        case temp_kf = "temp_kf"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temp = try values.decodeIfPresent(Double.self, forKey: .temp) ?? 0
        temp_min = try values.decodeIfPresent(Double.self, forKey: .temp_min) ?? 0
        temp_max = try values.decodeIfPresent(Double.self, forKey: .temp_max) ?? 0
        pressure = try values.decodeIfPresent(Double.self, forKey: .pressure) ?? 0
        sea_level = try values.decodeIfPresent(Double.self, forKey: .sea_level) ?? 0
        grnd_level = try values.decodeIfPresent(Double.self, forKey: .grnd_level) ?? 0
        humidity = try values.decodeIfPresent(Int.self, forKey: .humidity) ?? 0
        temp_kf = try values.decodeIfPresent(Double.self, forKey: .temp_kf) ?? 0
    }
    
}
