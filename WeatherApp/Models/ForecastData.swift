//
//  ForecastData.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 6/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ForecastData {
    let summary: String?
    let iconName: String?
    let temperature: Double?
    let temperatureHigh: Double?
    let temperatureLow: Double?
    let apparentTemperature: Double?
    let precipitationProbability: Double?
    let time: Date
}

extension ForecastData: ImmutableMappable {

    public init(map: Map) throws {
        summary = try? map.value("summary")
        iconName = try? map.value("icon")
        temperature = try? map.value("temperature")
        temperatureHigh = try? map.value("temperatureHigh")
        temperatureLow = try? map.value("temperatureLow")
        apparentTemperature = try? map.value("apparentTemperature")
        precipitationProbability = try? map.value("precipProbability")
        time = try map.value("time", using: DateTransform())
    }
    
    public mutating func mapping(map: Map) {
        summary >>> map["summary"]
        iconName >>> map["icon"]
        temperature >>> map["temperature"]
        temperatureHigh >>> map["temperatureHigh"]
        temperatureLow >>> map["temperatureLow"]
        apparentTemperature >>> map["apparentTemperature"]
        precipitationProbability >>> map["precipProbability"]
        time >>> (map["time"], DateTransform())
    }

}
