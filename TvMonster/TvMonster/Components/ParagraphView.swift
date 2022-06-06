//
//  ParagraphView.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI

struct ParagraphView: View {
    var descriptionText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(descriptionText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}

struct ParagraphView_Previews: PreviewProvider {
    static var previews: some View {
        ParagraphView(descriptionText: "Text here.")
    }
}
