//
//  Forecast.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 6/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Forecast {
    let current: ForecastData?
    let nextDays: ForecastBlock?
}

extension Forecast: ImmutableMappable {
    
    public init(map: Map) throws {
        current = try? map.value("currently")
        nextDays = try? map.value("daily")
    }
    
    public mutating func mapping(map: Map) {
        current >>> map["currently"]
        nextDays >>> map["daily"]
    }
}
