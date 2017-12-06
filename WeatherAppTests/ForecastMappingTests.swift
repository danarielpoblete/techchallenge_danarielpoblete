//
//  ForecastMappingTests.swift
//  WeatherAppTests
//
//  Created by Dan.Poblete on 6/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import XCTest
import ObjectMapper
@testable import WeatherApp

final class ForecastMappingTests: XCTestCase {
    
    private var forecast: Forecast!
    private var sampleDataJSONString: String!
    
    override func setUp() {
        super.setUp()
        
        guard let url = Bundle(for: type(of: self)).url(forResource: "sample-dark-sky-forecast", withExtension: "json") else {
            XCTFail("Missing JSON file: sample-dark-sky-forecast.json")
            return
        }
        
        guard let jsonString = try? String(contentsOf: url) else {
            XCTFail("Unable to get valid JSON string from file.")
            return
        }
        
        sampleDataJSONString = jsonString
        forecast = Mapper<Forecast>().map(JSONString: sampleDataJSONString)
    }
    
    override func tearDown() {
        forecast = nil
        sampleDataJSONString = nil
        
        super.tearDown()
    }
    
    func testThatMappingForecast_WithDarkSkySampleData_ShouldHaveAllForecastBlocks() {
        XCTAssertNotNil(forecast.current)
        XCTAssertNotNil(forecast.nextHours)
        XCTAssertNotNil(forecast.nextDays)
    }
    
    func testThatMappingForecast_WithDarkSkySampleData_ShouldHaveCorrectCurrentBlockData() {
        
    }
    
}
