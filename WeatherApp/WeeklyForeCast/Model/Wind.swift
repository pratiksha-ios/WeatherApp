//
//  Wind.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
struct Wind : Codable {
    let speed : Double?
    let deg : Double?
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed)
        deg = try values.decodeIfPresent(Double.self, forKey: .deg)
    }
}
