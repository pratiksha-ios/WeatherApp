//
//  Bindable.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class Bindable<T> {
    typealias Listener = ((T) -> Void)
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        self.value = v
    }
    
    func bind(_ listener: Listener?) {
        
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        
        self.listener = listener
        listener?(value)
    }
    
}
