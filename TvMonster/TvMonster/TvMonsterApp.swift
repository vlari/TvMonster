//
//  TvMonsterApp.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI

@main
struct TvMonsterApp: App {
    @StateObject var appBehavior = AppBehavior()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appBehavior)
        }
    }
}
