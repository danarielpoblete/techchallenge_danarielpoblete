//
//  ForecastListViewModel.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 6/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ForecastViewModelFetchStatus {
    case idle
    case busy
    case success
    case failed
}

protocol ForecastViewModelProtocol {
    var forecast: Driver<Forecast?> { get }
    var fetchForecastStatus: Driver<ForecastViewModelFetchStatus> { get }
    
    func fetchForecast()
    func showForecastData(_ forecastData: ForecastData)
}

public final class ForecastViewModel: ForecastViewModelProtocol {

    // MARK: - Properties
    // Outputs
    var forecast: Driver<Forecast?> {
        return _forecast.asDriver(onErrorJustReturn: nil)
    }
    
    var fetchForecastStatus: Driver<ForecastViewModelFetchStatus> {
        return _fetchForecastStatus.asDriver()
    }
    
    var action: Observable<Action> {
        return _action.asObservable()
    }
    
    // Helpers
    private let _forecast = PublishSubject<Forecast?>()
    private let _fetchForecastStatus = Variable<ForecastViewModelFetchStatus>(.idle)
    private let _action = PublishSubject<Action>()
    
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let weatherAPIService: WeatherAPIServiceProtocol
    
    // MARK: - Init
    init(weatherAPIService: WeatherAPIServiceProtocol) {
        self.weatherAPIService = weatherAPIService
    
        setupBindings()
    }
    
    // MARK: - Public Methods
    public func fetchForecast() {
        _action.onNext(.fetchForecast)
    }
    
    public func showForecastData(_ forecastData: ForecastData) {
        _action.onNext(.showForecastData(forecastData: forecastData))
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Sydney
        let latitude = 33.8650
        let longitude = 151.2094
        
        action
            .asObservable()
            .throttle(2, latest: false, scheduler: MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .filter { action in
                guard case .fetchForecast = action else {
                    return false
                }
                
                return true
            }
            .map { _ in
                ()
            }
            .do(onNext: { [unowned self] _ in
                self._fetchForecastStatus.value = .busy
            })
            .flatMap { [unowned self] _ in
                self.weatherAPIService.fetchForecast(latitude: latitude, longitude: longitude)
            }
            .map {
                Optional($0)
            }
            .do(
                onNext: { [unowned self] _ in
                    self._fetchForecastStatus.value = .success
                    self._fetchForecastStatus.value = .idle
                },
                onError: { [unowned self] _ in
                    self._fetchForecastStatus.value = .failed
                    self._fetchForecastStatus.value = .idle
            })
            .asDriver(onErrorJustReturn: nil)
            .drive(_forecast)
            .disposed(by: disposeBag)
    }
    
    enum Action {
        case fetchForecast
        case showForecastData(forecastData: ForecastData)
    }
}
