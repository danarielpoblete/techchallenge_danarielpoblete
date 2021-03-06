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
        XCTAssertNotNil(forecast.nextDays)
    }
    
    func testThatMappingForecast_WithDarkSkySampleData_ShouldHaveCorrectCurrentData() {
        XCTAssertEqual("Clear", forecast.current?.summary)
        XCTAssertEqual("clear-night", forecast.current?.iconName)
        XCTAssertEqual(45.98, forecast.current?.temperature)
        XCTAssertNil(forecast.current?.temperatureHigh)
        XCTAssertNil(forecast.current?.temperatureLow)
        XCTAssertEqual(44.72, forecast.current?.apparentTemperature)
        XCTAssertEqual(0, forecast.current?.precipitationProbability)
    }
    
    func testThatMappingForecast_WithDarkSkySampleData_ShouldHaveCorrectDailyBlock() {
        XCTAssertNotNil(forecast.nextDays?.summary)
        XCTAssertNotNil(forecast.nextDays?.iconName)
        XCTAssertEqual(8, forecast.nextDays?.data.count)
    }
}
