//
//  ContentView.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("istouchidenabled") public var isToushIdEnabled: Bool = false
    @AppStorage("isfirsttimeuser") public var isFirstTimeUser: Bool = true
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @EnvironmentObject var appBehavior: AppBehavior
    @EnvironmentObject var dataManager: DataManager
    @StateObject var authService = AuthenticationService()
    var dataService = TvDataService(dataManager: DataManager.shared)
    var tvService = TvApiService()
    
    var body: some View {
        Group {
            if appBehavior.isShowingLog {

                if isFirstTimeUser {
                    OnBoardingView(isFirstTimeUser: $isFirstTimeUser)
                } else {
                    LoginView(authService: authService, isShowingLog: $appBehavior.isShowingLog)
                }
                
            } else {
                ZStack(alignment: .bottom) {
                    switch selectedTab {
                    case .home:
                        MainShowsView(service: tvService, dataService: dataService)
                    case .people:
                        PeopleContainerView(service: tvService)
                    case .settings:
                        SettingsView(isToushIdEnabled: $isToushIdEnabled)
                    }
                    
                    TabBar()
                        .offset(y: appBehavior.showDetail ? 200 : 0)
                    
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Color.clear.frame(height: 88)
                }
            }
            
        }
        .onAppear {
            if authService.isPinBlank {
                appBehavior.isShowingLog = true
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
