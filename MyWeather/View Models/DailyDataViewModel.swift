//
//  DailyDataViewModel.swift
//  MyWeather
//
//  Created by Ernest Nyumbu on 2022/01/06.
//

import Foundation

struct DailyDataListViewModel {
    var dailyDataListViewModel: [DailyDataViewModel]
    init(){
        self.dailyDataListViewModel = [DailyDataViewModel]()
    }
}

extension DailyDataListViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.dailyDataListViewModel.count
    }
    
    func dailyDataViewModelAtIndex(_ index: Int) -> DailyDataViewModel {
        return self.dailyDataListViewModel[index]
    }
}

struct DailyDataViewModel {
    let dailyData: DailyData
}

extension DailyDataViewModel {
    
    var dt: Int {
        return self.dailyData.dt!
    }
    
    var sunrise: Int {
        return self.dailyData.sunrise!
    }
    
    var sunset: Int {
        return self.dailyData.sunset!
    }
    
    var temp: Temp {
        return self.dailyData.temp
    }
    
    var feelsLike: FeelsLike {
        return self.dailyData.feelsLike
    }
    var pressure: Int {
        return self.dailyData.pressure!
    }
    var humidity: Int {
        return self.dailyData.humidity!
    }
    var weather: [Weather] {
        return self.dailyData.weather
    }
    var speed: Double {
        return self.dailyData.speed!
    }
    
    var deg: Int {
        return self.dailyData.deg!
    }
    
    var gust: Double {
        return self.dailyData.gust!
    }
    
    var clouds: Int {
        return self.dailyData.clouds!
    }
    
    var pop: Double {
        return self.dailyData.pop!
    }
    
    var rain: Double {
        return self.dailyData.rain!
    }
    
    var weatherIconUrl: String {
        
        if weather.count > 0 {
            let weather = weather[0]
            if !weather.icon.isEmpty {
                return "\(Constants.AppConfig.WeatherIconsBaseURL)img/w/\(weather.icon).png"
            }
        }
        return ""
    }
    
    var subtitle: String {
        return "Max: \(temp.max)°, Min: \(temp.min)°"
    }
    
    func getDay(index: Int) -> String {
        
        if index == 0 {
            return "Today"
        }
        
        let today = Date()
        let requiredDate = Calendar.current.date(byAdding: .day, value: index, to: today)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let day = formatter.string(from: requiredDate!)
        return day
    }
}
