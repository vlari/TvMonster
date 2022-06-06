//
//  MinimalCard.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import SwiftUI
import Kingfisher


struct MinimalCard : View {
    var mediaTitle: String
    var image: String
    var cornerRadius: CGFloat = 22
    var fontStyle: Font = .title3
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            KFImage.url(URL(string: image ))
                .placeholder {
                    Image("tvplaceholder")
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cardStyle(cornerRadius: cornerRadius)
            
            HStack(alignment: .center) {
                Text(mediaTitle)
                    .font(fontStyle)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            
        }
        
    }
}
