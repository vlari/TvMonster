//
//  EpisodeSheetView.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI
import Kingfisher

struct EpisodeSheetView: View {
    @Environment(\.dismiss) var dismiss
    var name: String
    var season: Int
    var number: Int
    var summary: String
    var image: String
    
    var body: some View {
        ZStack {
            ScrollView {
                episodeBackground
                
                episodeDetail
                    .offset(y: 20)
                    .padding(.bottom, 200)
            }
            .ignoresSafeArea()

            closeButton
        }
    }
    
    var episodeBackground: some View {
        VStack {
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 400)
        .foregroundStyle(.black)
        .background(
            KFImage.url(URL(string: image))
                .placeholder {
                    Image("tvplaceholder")
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .frame(height: 400)
    }
    
    var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.body.weight(.bold))
                .foregroundColor(.secondary)
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(20)
        .ignoresSafeArea()
    }
    
    var episodeDetail: some View {
        VStack {
            Text(name)
                .font(.title.bold())
            
            HStack {
                Text("Season \(season)")
                    .font(.body)
                    .foregroundColor(.secondary)
                Circle()
                    .fill(Color.theme.green)
                    .frame(width: 12, height: 12)
                Text("Episode \(number)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            ParagraphView(descriptionText: summary)
                .padding()
        }
    }
}

struct EpisodeSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeSheetView(name: "Episode Name", season: 1, number: 4, summary: "Episode description here.", image: "tvplaceholder")
    }
}
