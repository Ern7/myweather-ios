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
        if let _value = self.dailyData.dt {
            return _value
        }
        return 0
    }
    
    var sunrise: Int {
        if let _value = self.dailyData.sunrise {
            return _value
        }
        return 0
    }
    
    var sunset: Int {
        if let _value = self.dailyData.sunset {
            return _value
        }
        return 0
    }
    
    var temp: Temp {
        return self.dailyData.temp
    }
    
    var feelsLike: FeelsLike {
        return self.dailyData.feelsLike
    }
    var pressure: Int {
        if let _value = self.dailyData.pressure {
            return _value
        }
        return 0
    }
    var humidity: Int {
        if let _value = self.dailyData.humidity {
            return _value
        }
        return 0
    }
    var weather: [Weather] {
        return self.dailyData.weather
    }
    var speed: Double {
        if let _value = self.dailyData.speed {
            return _value
        }
        return 0.0
    }
    
    var deg: Int {
        if let _value = self.dailyData.deg {
            return _value
        }
        return 0
    }
    
    var gust: Double {
        if let _value = self.dailyData.gust {
            return _value
        }
        return 0.0
    }
    
    var clouds: Int {
        if let _value = self.dailyData.clouds {
            return _value
        }
        return 0
    }
    
    var pop: Double {
        if let _value = self.dailyData.pop {
            return _value
        }
        return 0.0
    }
    
    var rain: Double {
        if let _value = self.dailyData.rain {
            return _value
        }
        return 0.0
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
        return "L: \(Int(temp.min.rounded()))° - H: \(Int(temp.max.rounded()))°"
    }
    
    func getDay(index: Int) -> String {
        
        if index == 0 {
            return "Today"
        }
        else if index == 1 {
            return "Tomorrow"
        }
        else {
            let today = Date()
            let requiredDate = Calendar.current.date(byAdding: .day, value: index, to: today)
            let formatter = DateFormatter()
            if index < 7 {
                formatter.dateFormat = "EEEE"
            }
            else {
                formatter.dateFormat = "EEEE dd MMMM"
            }
            let day = formatter.string(from: requiredDate!)
            return day
        }
        
    }
    
    var weatherAnimationName: String {
        //using weather codes found here: https://www.weatherbit.io/api/codes
        if weather.count > 0 {
            let weather = weather[0]
            if !weather.icon.isEmpty {
                if weather.id <= 233 {
                    return "82379-thunderstorm"
                }
                else if weather.id <= 522 {
                    return "82377-raining"
                }
                else if weather.id <= 610  {
                    return "10790-let-it-snow"
                }
                else if weather.id == 800  {
                    return "82378-sunny-weather"
                }
                else if weather.id == 802  {
                    return "22193-partly-cloudy"
                }
                else if weather.id <= 803 {
                    return "82375-cloudy-weather"
                }
                else if weather.id == 900 {
                    return "82377-raining"
                }
            }
        }
        return "82378-sunny-weather"
    }
    
    var displayTemperature: String {
        let hourOfDay = Calendar.current.component(.hour, from: Date())
        
        if hourOfDay < 6 {
            return "\(Int(temp.night.rounded()))°"
        }
        else if hourOfDay < 12 {
            return "\(Int(temp.morn.rounded()))°"
        }
        else if hourOfDay < 18 {
            return "\(Int(temp.day.rounded()))°"
        }
        else if hourOfDay < 24 {
            return "\(Int(temp.eve.rounded()))°"
        }
        
        return "\(Int(temp.day.rounded()))°"
    }
    
}
