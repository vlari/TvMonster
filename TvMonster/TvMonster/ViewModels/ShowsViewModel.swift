//
//  ShowsViewModel.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation

@MainActor
class ShowsViewModel: ObservableObject {
    @Published var shows = [Show]()
    @Published var resourceFetchedStatus = ResourceFetchedStatus<[Show]>.empty
    @Published var episodes: [Int : [Episode]] = [Int : [Episode]]()
    @Published var searchText: String = ""
    @Published var isWebDataSource: Bool = true
    var apiService: TvQueryable
    var dataService: DataPersistable
    var page: Int = 0
    
    init(service: TvQueryable, dataService: DataPersistable) {
        self.apiService = service
        self.dataService = dataService
    }
    
    func resetSearch() {
        page = 0
        shows.removeAll()
        resourceFetchedStatus = .successFetch(shows)
    }
    
    // MARK: - Api service methods
    func fetchShowsbySearch() async {
        guard Task.isCancelled == false else {
            return
        }

        do {
            let showSearched: [ShowSearched] = try await apiService.getShows(searchText: searchText)
            resetSearch()
            
            showSearched.forEach { showSearched in
                shows.append(showSearched.show)
            }
            
            guard Task.isCancelled == false else {
                return
            }
            
            resourceFetchedStatus = .successFetch(shows)
        } catch {
            print(error.localizedDescription)
            resourceFetchedStatus = .failedFetch(error)
        }
    }
    
    func loadPage() async {
        guard Task.isCancelled == false else {
            return
        }

        do {
            shows += try await apiService.getShows(page: page)
            page += 1
            
            guard Task.isCancelled == false else {
                return
            }
            
            resourceFetchedStatus = .successFetch(shows)
        } catch {
            print(error.localizedDescription)
            resourceFetchedStatus = .failedFetch(error)
        }
    }
    
    func fetchEpisodes(showId: Int) async {
        guard Task.isCancelled == false else {
            return
        }

        do {
            let fetchedpisodes = try await apiService.getEpisodes(showId: showId)
            guard Task.isCancelled == false else {
                return
            }
            
            episodes = Dictionary(grouping: fetchedpisodes, by: { $0.season })

        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Local persistence methods
    func fetchFavorites() {
        shows = dataService.getFavoriteShows(with: searchText)
        resourceFetchedStatus = .successFetch(shows)
    }
    
    func saveFavorite(show: Show?) {
        guard let show = show else { return }
        
        dataService.saveShow(show: show) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                if !self.isWebDataSource {
                    self.shows.removeAll()
                    self.fetchFavorites()
                }
            case .failure(let error):
                print("Error Saving show \(error)")
            }
        }
    }
    
    func isFavoriteShow(objectId: String) -> Bool {
        return dataService.isFavorite(objectId: objectId)
    }
    
    func deleteFavorite(objectId: String?) {
        guard let objectId = objectId else { return }
        dataService.deleteFavorite(objectId: objectId)
        
        if !isWebDataSource {
            fetchFavorites()
        }
    }
}

enum ResourceFetchedStatus<T> {
    case empty
    case successFetch(T)
    case fetchingNextPage(T)
    case failedFetch(Error)

    var value: T? {
        if case .successFetch(let value) = self {
            return value
        } else if case .fetchingNextPage(let value) = self {
            return value
        }
        return nil
    }
}
