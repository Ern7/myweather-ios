//
//  DailyForecastResponse.swift
//  MyWeather
//
//  Created by Ernest Nyumbu on 2022/01/06.
//

import Foundation

struct DailyForecastResponse : Codable {
    let city: City
    let cod: String
    let message: Double?
    let cnt: Int?
    let list: [DailyData]
    
}

extension DailyForecastResponse {
    
    static var all: WebResource<DailyForecastResponse> = {
        
        guard let url = URL(string: "\(Constants.AppConfig.BackendUrl)forecast/daily?q=johannesburg%2Czaf&lat=35&lon=139&cnt=5&units=metric") else {
            fatalError("URL is incorrect!")
        }
        
        return WebResource<DailyForecastResponse>(url: url)
    }()
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}
