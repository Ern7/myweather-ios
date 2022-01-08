//
//  DailyDataListViewModelTests.swift
//  MyWeatherTests
//
//  Created by Ernest Nyumbu on 2022/01/08.
//

import XCTest
import Combine
@testable import MyWeather

class DailyDataListViewModelTests: XCTestCase {
    
    var sut: DailyDataListViewModel!
    var testLatitude: Double!
    var testLongitude: Double!
    var customObservers: [AnyCancellable] = []
    
    override func setUp() {
        super.setUp()
        sut = DailyDataListViewModel()
        testLatitude = -26.2041
        testLongitude = 28.0473
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testItemViewModelAtIndexExtensionMethod(){
        let expectation = self.expectation(description: "fetch weather forecast and check if fetched item in list is correct.")
        
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
            }, receiveValue: { [weak self] value in
                XCTAssertNotNil(value)
                self?.sut.dailyDataListViewModel = value.list.map(DailyDataViewModel.init)
                
                let position = 3
                let itemViewModel = self?.sut.dailyDataViewModelAtIndex(position)
                    
                XCTAssertNotNil(itemViewModel)
                
                XCTAssertEqual(itemViewModel?.dt, value.list[position].dt)
                
                XCTAssertEqual(self?.sut.numberOfRowsInSection(0), value.list.count)
                
            }).store(in: &customObservers)
        
        
        
        self.waitForExpectations(timeout: 6.0, handler: nil)
    }
    
    func testNumberOfRowsInSectionExtensionMethod(){
        let expectation = self.expectation(description: "fetch weather forecast and check if number of items returned from API matches number of rows used in tableview.")
        
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
            }, receiveValue: { [weak self] value in
                XCTAssertNotNil(value)
                
                self?.sut.dailyDataListViewModel = value.list.map(DailyDataViewModel.init)
                
                XCTAssertEqual(self?.sut.numberOfRowsInSection(0), value.list.count)
                
            }).store(in: &customObservers)
        
        
        
        self.waitForExpectations(timeout: 6.0, handler: nil)
    }
}
  
