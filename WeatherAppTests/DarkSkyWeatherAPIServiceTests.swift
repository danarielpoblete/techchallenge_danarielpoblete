//
//  DarkSkyWeatherAPIServiceTests.swift
//  WeatherAppTests
//
//  Created by Dan.Poblete on 7/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Moya
import RxBlocking
@testable import WeatherApp

final class DarkSkyWeatherAPIServiceTests: XCTestCase {
    
    private var weatherAPIService: DarkSkyWeatherAPIService!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        weatherAPIService = nil
        disposeBag = nil
        
        super.tearDown()
    }
    
    func testThatFetchingForecast_WithLatitudeAndLongitude_ShouldReturnForecast() {
        // Given
        let stubClosure: MoyaProvider<DarkSky>.StubClosure = { target in
            switch target {
            case .forecast: return .immediate
            }
        }
        let provider = MoyaProvider<DarkSky>(stubClosure: stubClosure)
        weatherAPIService = DarkSkyWeatherAPIService(provider: provider)
        
        // When
        let result = try! weatherAPIService.fetchForecast(latitude: 1.0, longitude: 1.0)
            .toBlocking()
            .single()
        
        // Then
        XCTAssertNotNil(result)
    }
    
    func testThatFetchingForecast_WithFailedNetworkRequest_ShouldThrowError() {
        // Given
        let stubClosure: MoyaProvider<DarkSky>.StubClosure = { target in
            switch target {
            case .forecast: return .immediate
            }
        }
        let endpointClosure: MoyaProvider<DarkSky>.EndpointClosure = { target -> Endpoint<DarkSky> in
            let url = URL(target: target).absoluteString
            return Endpoint(url: url, sampleResponseClosure: {.networkResponse(400, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }
        let provider = MoyaProvider<DarkSky>(endpointClosure: endpointClosure, stubClosure: stubClosure)
        
        weatherAPIService = DarkSkyWeatherAPIService(provider: provider)
        
        // When
        let fetchForecast = weatherAPIService.fetchForecast(latitude: 1.0, longitude: 1.0)
        
        // Then
        XCTAssertThrowsError(try fetchForecast.toBlocking().toArray())
    }
}
