//
//  City.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class City: Object, Codable {
    dynamic var id : Int = 0
    dynamic var name : String? = ""
    dynamic var country : String? = ""
    dynamic var coord : Coord? = nil

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case country = "country"
        case coord = "coord"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try values.decodeIfPresent(String.self, forKey: .name)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        coord = try values.decodeIfPresent(Coord.self, forKey: .coord)
        
    }
}
