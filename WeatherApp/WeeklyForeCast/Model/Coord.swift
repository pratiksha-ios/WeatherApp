//
//  Coord.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Coord: Object, Codable {
    dynamic var lat : Double = 0
    dynamic var lon : Double = 0
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat) ?? 0
        lon = try values.decodeIfPresent(Double.self, forKey: .lon) ?? 0
    }
    
}
