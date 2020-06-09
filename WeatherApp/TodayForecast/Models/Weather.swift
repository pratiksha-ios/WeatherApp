//
//  Weather.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Weather: Object, Codable {
    dynamic var id : Int = 0
    dynamic var main : String? = ""
    dynamic var descriptionWeather : String? = ""
    dynamic var icon : String? = ""
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case main = "main"
        case descriptionWeather = "description"
        case icon = "icon"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        main = try values.decodeIfPresent(String.self, forKey: .main)
        descriptionWeather = try values.decodeIfPresent(String.self, forKey: .descriptionWeather)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
    }
    
}
