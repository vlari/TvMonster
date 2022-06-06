//
//  APIManager.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation

protocol ApiManager {
    func fetch<T: Decodable>(endpoint: ApiEndpoint, responseModel: T.Type) async throws -> T
}

extension ApiManager {
    
    func fetch<T: Decodable>(endpoint: ApiEndpoint, responseModel: T.Type) async throws -> T {
        let urlComponents = getUrlComponents(from: endpoint)
        guard let url = urlComponents.url else {
            throw ApiError.invalidUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw ApiError.badResponse
        }
        
        switch response.statusCode {
        case (200...299):
            let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
            
            return decodedResponse
        case (400...499):
            throw ApiError.clientError
        default:
            throw ApiError.networkError
        }
        
    }
    
    private func getUrlComponents(from endpoint: ApiEndpoint) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.baseURL
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.parameters
        
        return urlComponents
    }
    
    private func createRequest(from endpoint: ApiEndpoint) throws -> URLRequest {
        let urlComponents = getUrlComponents(from: endpoint)
        guard let url = urlComponents.url else {
            throw ApiError.invalidUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        return urlRequest
    }
}
