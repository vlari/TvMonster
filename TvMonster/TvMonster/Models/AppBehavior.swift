//
//  AppBehavior.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import Foundation

class AppBehavior: ObservableObject {
    @Published var showDetail: Bool = false
    @Published var isShowingLog: Bool = true
    @Published var authReason = AuthReason.login
}

enum AuthReason {
    case login
    case newPin
}
