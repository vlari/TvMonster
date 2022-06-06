//
//  TvApiService.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation

protocol TvQueryable {
    func getShows(page: Int) async throws -> [Show]
    func getShows(searchText: String) async throws -> [ShowSearched]
    func getEpisodes(showId: Int) async throws -> [Episode]
    func getCredits(personId: Int) async throws -> [CreditResponse]
    func getPeople(searchText: String) async throws -> [PersonResponse]
}

struct TvApiService: ApiManager, TvQueryable {
    func getCredits(personId: Int) async throws -> [CreditResponse] {
        return try await fetch(endpoint: TvEndpoint.getCredits(personId: personId), responseModel: [CreditResponse].self)
    }
    
    func getPeople(searchText: String) async throws -> [PersonResponse] {
        return try await fetch(endpoint: TvEndpoint.getPeople(searchText: searchText), responseModel: [PersonResponse].self)
    }
    
    func getEpisodes(showId: Int) async throws -> [Episode] {
        return try await fetch(endpoint: TvEndpoint.getEpisodes(showId: showId), responseModel: [Episode].self)
    }
    
    func getShows(page: Int = 0) async throws -> [Show] {
        return try await fetch(endpoint: TvEndpoint.getSearchResult(page: page), responseModel: [Show].self)
    }
    
    func getShows(searchText: String) async throws -> [ShowSearched] {
        return try await fetch(endpoint: TvEndpoint.getShowsBy(searchText: searchText), responseModel: [ShowSearched].self)
    }
}
