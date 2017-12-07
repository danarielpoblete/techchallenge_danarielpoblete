
//
//  Services.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 8/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import Moya

public struct Services {
    
    public let weatherAPIService: WeatherAPIServiceProtocol
    
    public init() {
        let provider = MoyaProvider<DarkSky>()
        self.weatherAPIService = DarkSkyWeatherAPIService(provider: provider)
    }
    
}
