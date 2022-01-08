//
//  DailyForecastViewModelTests.swift
//  MyWeatherTests
//
//  Created by Ernest Nyumbu on 2022/01/08.
//

import XCTest
import Combine
@testable import MyWeather

class DailyForecastViewModelTests: XCTestCase {

    var testLatitude: Double!
    var testLongitude: Double!
    var customObservers: [AnyCancellable] = []
    
    override func setUp() {
        super.setUp()
        testLatitude = -26.2041
        testLongitude = 28.0473
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testViewModelDataMapping(){
        let expectation = self.expectation(description: "fetch weather forecast and check if cod is correctly mapped to cod property view model.")
        
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
                let sut = DailyForecastViewModel(value)
                    
                XCTAssertNotNil(sut)
                
                XCTAssertEqual(sut.city.id, value.city.id)
                XCTAssertEqual(sut.cod, value.cod)
                XCTAssertEqual(sut.cnt, value.cnt)
                XCTAssertEqual(sut.message, value.message)
                XCTAssertEqual(sut.list.count, value.list.count)
                
            }).store(in: &customObservers)
        
        
        
        self.waitForExpectations(timeout: 6.0, handler: nil)
    }

}
