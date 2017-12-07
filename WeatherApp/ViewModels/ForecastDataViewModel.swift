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
}

public final class ForecastDataViewModel: ForecastDataViewModelProtocol {
    
    // MARK: - Properties
    // Outputs
    var forecastData: Driver<ForecastData>
    
    // MARK: - Init
    init(forecastData: ForecastData) {
        self.forecastData = Driver.just(forecastData)
    }
}
