//
//  APIEndpoint.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation

protocol ApiEndpoint {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
}
