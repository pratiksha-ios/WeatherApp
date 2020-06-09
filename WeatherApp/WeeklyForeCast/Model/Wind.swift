//
//  Wind.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Wind: Object, Codable {
    dynamic var speed : Double = 0
    dynamic var deg : Double = 0

    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed) ?? 0
        deg = try values.decodeIfPresent(Double.self, forKey: .deg) ?? 0
    }
}
