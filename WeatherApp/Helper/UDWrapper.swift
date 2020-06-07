//
//  UDWrapper.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class UDWrapper{
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Get value
    //------------------
    
    class func getString(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Set value
    //-------------------------------------------------------------------------------------------
    
    
    class func setString(key: String, value: NSString?) {
        if (value == nil) {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(value, forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Synchronize
    //-------------------------------------------------------------------------------------------
    
    class func Sync() {
        UserDefaults.standard.synchronize()
    }
}
