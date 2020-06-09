//
//  Clouds.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Clouds: Object, Codable {
    dynamic var all : Int = 0
    
    enum CodingKeys: String, CodingKey {
        case all = "all"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        all = try values.decodeIfPresent(Int.self, forKey: .all) ?? 0
    }
    
}
