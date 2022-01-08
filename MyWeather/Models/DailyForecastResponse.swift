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
    
    static var getPretoriaForTesting: WebResource<DailyForecastResponse> = {
        
        guard let url = URL(string: "\(Constants.AppConfig.BackendUrl)forecast/daily?q=pretoria%2Czaf&lat=-25.7479&lon=28.2293&cnt=16&units=metric") else {
            fatalError("URL is incorrect!")
        }
        
        return WebResource<DailyForecastResponse>(url: url)
    }()
    
    static func getForecast(latitude: Double, longitude: Double, daysCount: Int = 7) -> WebResource<DailyForecastResponse> {
        
        guard let url = URL(string: "\(Constants.AppConfig.BackendUrl)forecast/daily?q=johannesburg%2Czaf&lat=\(latitude)&lon=\(longitude)&cnt=\(daysCount)&units=metric") else {
            fatalError("URL is incorrect!")
        }
        
        return WebResource<DailyForecastResponse>(url: url)
    }
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
