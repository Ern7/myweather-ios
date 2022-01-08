//
//  DailyForecastListViewModelTests.swift
//  MyWeatherTests
//
//  Created by Ernest Nyumbu on 2022/01/08.
//

import XCTest
import Combine
@testable import MyWeather

class DailyForecastListViewModelTests: XCTestCase {

    var sut: DailyForecastListViewModel!
    var testLatitude: Double!
    var testLongitude: Double!
    var customObservers: [AnyCancellable] = []
    
    override func setUp() {
        super.setUp()
        sut = DailyForecastListViewModel(dailyForecastList: [DailyForecastResponse]())
        testLatitude = -26.2041
        testLongitude = 28.0473
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testReceiveDataFromServiceLayer() {
        let expectation = self.expectation(description: "fetch weather forecast.")
        DailyForecastListViewModel.fetch(latitude: testLatitude, longitude: testLongitude, daysCount: Constants.AppConfig.ForecastDays)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    DebuggingLogger.printData("finished")
                case .failure(let error):
                    XCTAssertNil(error)
                }
                expectation.fulfill()
            }, receiveValue: { value in
                XCTAssertNotNil(value)
            }).store(in: &customObservers)
        
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
  

