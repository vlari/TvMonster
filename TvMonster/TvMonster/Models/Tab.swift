//
//  Tab.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: String
    var tab: Tab
    var color: Color = Color.theme.green
}

var tabItems = [
    TabItem(text: "Home", icon: "house", tab: .home),
    TabItem(text: "People", icon: "theatermasks", tab: .people),
    TabItem(text: "Settings", icon: "gearshape", tab: .settings)
]

enum Tab: String {
    case home
    case people
    case settings
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
