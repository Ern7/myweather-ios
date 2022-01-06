//
//  NetworkError.swift
//  MyWeather
//
//  Created by Ernest Nyumbu on 2022/01/06.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}
