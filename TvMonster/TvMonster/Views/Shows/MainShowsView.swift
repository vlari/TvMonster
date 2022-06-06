//
//  MainShowView.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI

struct MainShowsView: View {
    @EnvironmentObject var appBehavior: AppBehavior
    @StateObject var vm: ShowsViewModel
    @State var isShowingDetail = false
    
    init(service: TvQueryable, dataService: DataPersistable) {
        _vm = StateObject(wrappedValue: ShowsViewModel(service: service, dataService: dataService))
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                if !appBehavior.showDetail {
                    searchSection
                }
                
                ShowsListView(vm: vm)
                    .overlay(
                        overlayView
                    )
                    .task {
                        if vm.isWebDataSource {
                            await vm.loadPage()
                        }
                    }
            }
        }
    }
    
    var searchSection: some View {
        HStack {
            SearchBarView(searchText: $vm.searchText, textPlaceholder: vm.isWebDataSource ? "Search shows" : "Search your favorite shows" , onConfirm: {
                
                if vm.isWebDataSource {
                    Task {
                        await vm.fetchShowsbySearch()
                    }
                } else {
                    vm.fetchFavorites()
                }
            }, onCancel: {
                vm.resetSearch()
                if vm.isWebDataSource {
                    Task {
                        await vm.loadPage()
                    }
                } else {
                    vm.fetchFavorites()
                }
            })
            
            Button {
                vm.isWebDataSource.toggle()
                
                if vm.isWebDataSource {
                    Task {
                        vm.resetSearch()
                        await vm.loadPage()
                    }
                } else {
                    vm.searchText = ""
                    vm.fetchFavorites()
                }
            } label: {
                Image(systemName: vm.isWebDataSource ? "bookmark" : "cloud")
                    .font(.title)
                    .foregroundColor(Color.theme.green)
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(TTapButtontyle())
            
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch vm.resourceFetchedStatus {
        case .empty:
            TProgressView()
        case .successFetch(let shows) where shows.isEmpty:
            Text("No shows found")
                .font(.system(.title, design: .rounded))
                .foregroundColor(Color.theme.green.opacity(0.6))
        case .failedFetch(let error):
            Text(error.localizedDescription)
        default:
            EmptyView()
        }
    }
}

struct MainShowView_Previews: PreviewProvider {
    static var previews: some View {
        MainShowsView(service: TvApiService(), dataService: TvDataService(dataManager: DataManager.shared))
    }
}
