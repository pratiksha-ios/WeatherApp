//
//  Wind.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class Wind: Object, Codable {
    dynamic var speed : Double?
    dynamic var deg : Double?

    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed)
        deg = try values.decodeIfPresent(Double.self, forKey: .deg)
    }
}
