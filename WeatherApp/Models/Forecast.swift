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
    let nextHours: ForecastBlock?
    let nextDays: ForecastBlock?
}

extension Forecast: ImmutableMappable {
    
    public init(map: Map) throws {
        current = try? map.value("currently")
        nextHours = try? map.value("hourly")
        nextDays = try? map.value("daily")
    }
    
    public mutating func mapping(map: Map) {
        current >>> map["currently"]
        nextHours >>> map["hourly"]
        nextDays >>> map["daily"]
    }
}
