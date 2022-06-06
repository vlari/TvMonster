//
//  PeopleContainerView.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import SwiftUI

struct PeopleContainerView: View {
    @EnvironmentObject var appBehavior: AppBehavior
    @StateObject var peopleVM: PeopleViewModel
    
    init(service: TvQueryable) {
        _peopleVM = StateObject(wrappedValue: PeopleViewModel(service: service))
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                if !appBehavior.showDetail {
                    SearchBarView(searchText: $peopleVM.searchText, onConfirm: {
                        Task {
                            await peopleVM.fetchPeople()
                        }
                    }, onCancel: {
                        peopleVM.resetSearch()
                    })
                    .padding()
                }
                
                PeopleListView(peopleVM: peopleVM)
                    .overlay(
                        overlayView
                    )
            }
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch peopleVM.resourceFetchedStatus {
        case .empty:
            EmptyView()
        case .successFetch(let shows) where shows.isEmpty:
            Text("No people found")
                .font(.system(.title, design: .rounded))
                .foregroundColor(Color.theme.green.opacity(0.6))
        case .failedFetch(let error):
            Text(error.localizedDescription)
        default:
            EmptyView()
        }
    }
}

struct PeopleContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleContainerView(service: TvApiService())
    }
}
