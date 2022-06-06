//
//  APIError.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation

enum ApiError: Error {
    case invalidUrl
    case badResponse
    case clientError
    case decodeError
    case networkError
}

extension ApiError {
    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return "Invalid Url Error"
        case .badResponse:
            return "Bad Response"
        case .clientError:
            return "Client Error"
        case .decodeError:
            return "Decode Error"
        default:
            return "Api Request Error"
        }
    }
}
