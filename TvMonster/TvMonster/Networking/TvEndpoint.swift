//
//  TvEndpoint.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation

enum TvEndpoint: ApiEndpoint {
    case getSearchResult(page: Int)
    case getEpisodes(showId: Int)
    case getShowsBy(searchText: String)
    case getPeople(searchText: String)
    case getCredits(personId: Int)
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return "api.tvmaze.com"
        }
    }
    
    var path: String {
        switch self {
        case .getSearchResult:
            return "/shows"
        case .getEpisodes(let showId):
            return "/shows/\(showId)/episodes"
        case .getShowsBy:
            return "/search/shows"
        case .getPeople:
            return "/search/people"
        case .getCredits(let personId):
            return "/people/\(personId)/castcredits"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getSearchResult(let page):
            return [URLQueryItem(name: "page", value: String(page))]
        case .getEpisodes:
            return []
        case .getShowsBy(let searchText), .getPeople(let searchText):
            return [URLQueryItem(name: "q", value: searchText)]
        case .getCredits:
            return [URLQueryItem(name: "embed", value: "show")]
        }
    }
    
    var method: String {
        switch self {
        case .getSearchResult, .getEpisodes, .getShowsBy, .getPeople, .getCredits:
            return "GET"
        }
    }
}
