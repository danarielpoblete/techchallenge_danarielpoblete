//
//  WeatherAPIService.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 6/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Moya_ObjectMapper

public protocol WeatherAPIServiceProtocol {
    func fetchForecast(latitude: Double, longitude: Double) -> Single<Forecast>
}

public final class DarkSkyWeatherAPIService: WeatherAPIServiceProtocol {
    
    // MARK: - Properties
    // Dependencies
    private let provider: MoyaProvider<DarkSky>
    
    // MARK: - Init
    init(provider: MoyaProvider<DarkSky>) {
        self.provider = provider
    }
    
    // MARK: - Public Methods
    public func fetchForecast(latitude: Double, longitude: Double) -> Single<Forecast> {
        return provider.rx.request(.forecast(latitude: latitude, longitude: longitude))
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .filterSuccessfulStatusAndRedirectCodes()
            .mapObject(Forecast.self)
            .observeOn(MainScheduler.instance)
    }
    
}
