//
//  ShowsListView.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI

struct ShowsListView: View {
    @EnvironmentObject var appBehavior: AppBehavior
    @ObservedObject var vm: ShowsViewModel
    @Namespace var namespace
    @State private var selectedShow: Show?
    @State private var showStatusBar = true
    @State private var isShowingDetail = false
    @State private var show = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 4) {
                    Text("Shows")
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                        spacing: 20
                    ) {
                        
                        ForEach(vm.shows) { item in
                            
                            VStack {
                                MediaCard(show: item, namespace: namespace)
                                    .onTapGesture {
                                        withAnimation(.openCard) {
                                            show.toggle()
                                            appBehavior.showDetail.toggle()
                                            showStatusBar = false
                                            selectedShow = item
                                            
                                        }
                                    }
                                    .task {
                                        if (item == vm.shows.last && vm.searchText.isEmpty) && vm.isWebDataSource {
                                            await vm.loadPage()
                                        }
                                    }
                            }
                            
                        }
                        
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                }
                
                
            }
            
            if show {
                ShowDetailView(vm: vm, show: $show, namespace: namespace, selectedShow: selectedShow, episodes: vm.episodes)
                    .zIndex(1)
                    .transition(.asymmetric(
                        insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                        removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))))
                
            }
            
        }
        .statusBar(hidden: !showStatusBar)
        .onChange(of: show) { newValue in
            withAnimation(.closeCard) {
                if newValue {
                    showStatusBar = false
                } else {
                    showStatusBar = true
                }
            }
        }
        
    }
}

struct ShowsListView_Previews: PreviewProvider {
    static var previews: some View {
        ShowsListView(vm: ShowsViewModel(service: TvApiService(), dataService: TvDataService(dataManager: DataManager.shared)))
    }
}
