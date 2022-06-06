//
//  Rating.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI

struct Rating: View {
    var ratingValue: String
    var body: some View {
        HStack {
            Text("\(ratingValue)/10")
                .font(.headline)
            Image(systemName: "star.fill")
                .foregroundColor(Color.theme.green)
        }
    }
}

struct Rating_Previews: PreviewProvider {
    static var previews: some View {
        Rating(ratingValue: "9")
    }
}
