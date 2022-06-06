//
//  SearchBarView.swift.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var textPlaceholder: String = "Search"
    var onConfirm: () async -> Void
    var onCancel: () async -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? Color.gray : Color.theme.green)
            
            TextField(textPlaceholder, text: $searchText)
                .foregroundColor(Color.theme.green)
                .overlay(
                    Image(systemName: "xmark")
                        .padding()
                        .background(
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 40, height: 40)
                        )
                        .offset(x: 10)
                        .foregroundColor(Color.theme.green)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                            Task {
                                await onCancel()
                            }
                        }
                    , alignment: .trailing
                )
                .onSubmit {
                    Task {
                        await onConfirm()
                    }
                }
            
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.theme.green.opacity(0.1))
        )
        .padding(.vertical)
        .padding(.trailing)
        
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""), onConfirm: {}, onCancel: {})
            .previewLayout(.sizeThatFits)
    }
}
