//
//  PeopleViewModel.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import Foundation

@MainActor
class PeopleViewModel: ObservableObject {
    @Published var people =  [Person]()
    @Published var personCredits =  [CreditShow]()
    @Published var resourceFetchedStatus = ResourceFetchedStatus<[Person]>.empty
    @Published var searchText: String = ""
    var apiService: TvQueryable
    
    init(service: TvQueryable) {
        self.apiService = service
    }
    
    func resetSearch() {
        people.removeAll()
        resourceFetchedStatus = .successFetch(people)
    }
    
    func fetchPeople() async {
        guard Task.isCancelled == false else {
            return
        }

        do {
            let peopleSearched: [PersonResponse] = try await apiService.getPeople(searchText: searchText)
            resetSearch()
            
            peopleSearched.forEach { personSearched in
                people.append(personSearched.person)
            }
            
            guard Task.isCancelled == false else {
                return
            }
            
            resourceFetchedStatus = .successFetch(people)
        } catch {
            print(error.localizedDescription)
            resourceFetchedStatus = .failedFetch(error)
        }
    }
    
    func fetchPersonCredits(personId: Int) async {
        guard Task.isCancelled == false else {
            return
        }

        do {
            let credits: [CreditResponse] = try await apiService.getCredits(personId: personId)
            personCredits.removeAll()
            
            credits.forEach { credit in
                personCredits.append(credit.embedded.show)
            }
            
            guard Task.isCancelled == false else {
                return
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
