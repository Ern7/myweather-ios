//
//  WeatherApiService.swift
//  MyWeather
//
//  Created by Ernest Nyumbu on 2022/01/06.
//

import Foundation

class WeatherApiService {
    static let shared = WeatherApiService()
    
    func load<T>(resource: WebResource<T>, completion: @escaping (Result<T, NetworkError>) -> Void){
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("community-open-weather-map.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.addValue(Constants.ApiKeys.RapidApiKey, forHTTPHeaderField: "x-rapidapi-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }
            else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
}
