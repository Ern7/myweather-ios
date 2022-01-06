//
//  NetworkError.swift
//  MyWeather
//
//  Created by Ernest Nyumbu on 2022/01/06.
//

import Foundation

struct APICallError: Error {
    enum ErrorKind {
        case decodingError
        case domainError
        case urlError
        case serverError
    }

    let message: String
    let kind: ErrorKind
}
