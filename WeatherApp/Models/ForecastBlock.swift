//
//  ForecastBlock.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 6/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ForecastBlock {
    let summary: String?
    let iconName: String?
    let data: [ForecastData]
}

extension ForecastBlock: ImmutableMappable {
    
    public init(map: Map) throws {
        summary = try? map.value("summary")
        iconName = try? map.value("icon")
        data = (try? map.value("data")) ?? []
    }
    
    public mutating func mapping(map: Map) {
        summary >>> map["summary"]
        iconName >>> map["icon"]
        data >>> map["data"]
    }
}
