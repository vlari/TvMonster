//
//  Animation+Extension.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI

extension Animation {
    static let openCard = Animation.spring(response: 0.5, dampingFraction: 0.7)
    static let closeCard = Animation.spring(response: 0.6, dampingFraction: 0.9)
}
