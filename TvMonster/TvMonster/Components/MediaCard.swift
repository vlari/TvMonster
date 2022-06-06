//
//  MediaCard.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI
import Kingfisher


struct MediaCard: View {
    var show: Show
    var cornerRadius: CGFloat = 22
    var namespace: Namespace.ID
    
    func getformattedName(name: String?) -> String {
        guard let name = name else { return "" }
        let formattedName = name.count > 20 ? name + "\n" : name
        return formattedName
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            KFImage.url(URL(string: show.image?.medium ?? ""))
                .placeholder {
                    Image("tvplaceholder")
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cardStyle(cornerRadius: cornerRadius)
                .matchedGeometryEffect(id: "image\(show.id)", in: namespace)
            
            HStack {
                Text(getformattedName(name: show.name))
                    .lineLimit(2)
                    .font(.title3.bold())
            }
            
            HStack {
                Text(show.genres?.first ?? "-")
                    .font(.headline)
                    .matchedGeometryEffect(id: "genre\(show.id)", in: namespace)
                
                Spacer()
                
                Rating(ratingValue: FormatterManager.shared.getRating(rating: show.rating?.average))
                .matchedGeometryEffect(id: "stars\(show.id)", in: namespace)
            }
            .foregroundColor(Color.secondary)
        }
        
    }
}
