//
//  DailyForecastViewModel.swift
//  MyWeather
//
//  Created by Ernest Nyumbu on 2022/01/06.
//

import Foundation
import Combine

struct DailyForecastListViewModel {
    let dailyForecastList: [DailyForecastResponse]
}

extension DailyForecastListViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.dailyForecastList.count
    }
    
    func dailyForecastAtIndex(_ index: Int) -> DailyForecastViewModel {
        let dailyForecast = self.dailyForecastList[index]
        return DailyForecastViewModel(dailyForecast)
    }
    
    static func fetch(latitude: Double, longitude: Double, daysCount: Int = 7) -> Future<DailyForecastResponse, APICallError> {
        return Future { promixe in
            WeatherApiService.shared.load(resource: DailyForecastResponse.getForecast(latitude: latitude, longitude: longitude, daysCount: daysCount)) { result in
                switch result {
                case .success(let dailyForecast):
                    DebuggingLogger.printData(dailyForecast)
                    promixe(.success(dailyForecast))
                case .failure(let error):
                    DebuggingLogger.printData(error)
                    promixe(.failure(error))
                }
            }
        }
    }
}

struct DailyForecastViewModel {
    private let dailyForecast: DailyForecastResponse
}

extension DailyForecastViewModel {
    init(_ dailyForecast: DailyForecastResponse) {
        self.dailyForecast = dailyForecast
    }
}

extension DailyForecastViewModel {
    
    var city: City {
        return self.dailyForecast.city
    }
    
    var cod: String {
        return self.dailyForecast.cod
    }
    
    var message: Double {
        return self.dailyForecast.message!
    }
    
    var cnt: Int {
        return self.dailyForecast.cnt!
    }
    
    var list: [DailyData] {
        return self.dailyForecast.list
    }
}
