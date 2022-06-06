//
//  EpisodeCard.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI

struct EpisodeCard: View {
    var name: String
    var episodeNumber: Int
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.theme.green)
                .frame(width: 80, height: 60)
                .overlay(
                    Image(systemName: "play.fill")
                        .font(.title)
                        .foregroundColor(.white)
                )
            
            Text("\(episodeNumber). \(name)")
                .font(.headline.bold())
            
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(22)
        .padding()
        .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 4)
        
        
        
    }
}

struct EpisodeCard_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeCard(name: "Episode name", episodeNumber: 1)
    }
}
