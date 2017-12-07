//
//  Double+ToCelsius.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 7/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation

extension Double {
    
    func toCelsius() -> Double {
        return 5.0 / 9.0 * (self - 32.0)
    }
    
}
