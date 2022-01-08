//
//  WeatherApiServiceTests.swift
//  MyWeatherTests
//
//  Created by Ernest Nyumbu on 2022/01/08.
//


import XCTest
@testable import MyWeather

class WeatherApiServiceTests: XCTestCase {
    
    var sut: WeatherApiService!
    var testLatitude: Double!
    var testLongitude: Double!
    
    override func setUp() {
        super.setUp()
        sut = WeatherApiService.shared
        testLatitude = -26.2041
        testLongitude = 28.0473
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadWeatherForecast() {
        
        let expectation = self.expectation(description: "fetch weather forecast.")
        
        sut.load(resource: DailyForecastResponse.getForecast(latitude: testLatitude, longitude: testLongitude, daysCount: Constants.AppConfig.ForecastDays)) {result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 6.0, handler: nil)
        
    }

    func testLoadPretoriaWeatherForecast() {
        
        let expectation = self.expectation(description: "fetch pretoria weather forecast.")
        
        sut.load(resource: DailyForecastResponse.getPretoriaForTesting) {result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 6.0, handler: nil)
        
    }
    
    func testErrorHandlingWhenFetchingForecast() {
        
        let incorrectUrlResource: WebResource<DailyForecastResponse> = {
            //intentionally using wrong URL
            guard let url = URL(string: "\(Constants.AppConfig.BackendUrl)fffffforecast/daily?q=johannesburg%2Czaf&lat=\(testLatitude)&lon=\(testLongitude)&cnt=\(Constants.AppConfig.ForecastDays)&units=metric") else {
                fatalError("URL is incorrect!")
            }
            
            return WebResource<DailyForecastResponse>(url: url)
        }()
        
        let expectation = self.expectation(description: "fetch weather forecast failed.")
        
        sut.load(resource: incorrectUrlResource) { result in
            switch result {
            case .success(let nasaResponse):
                XCTAssertNotNil(nasaResponse)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 6.0, handler: nil)
        
    }
}
