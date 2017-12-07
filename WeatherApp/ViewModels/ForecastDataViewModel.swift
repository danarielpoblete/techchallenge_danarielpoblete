//
//  ForecastDataViewModel.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 7/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ForecastDataViewModelProtocol {
    var forecastData: Driver<ForecastData> { get }
    var location: Driver<String> { get }
}

public final class ForecastDataViewModel: ForecastDataViewModelProtocol {
    
    // MARK: - Properties
    // Outputs
    var forecastData: Driver<ForecastData>
    var location: Driver<String>
    
    // MARK: - Init
    init(forecastData: ForecastData, location: String) {
        self.forecastData = Driver.just(forecastData)
        self.location = Driver.just(location)
    }
}
