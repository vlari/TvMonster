//
//  PersonSheet.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import SwiftUI
import Kingfisher

struct PersonSheetView: View {
    @EnvironmentObject var appBehavior: AppBehavior
    @Environment(\.dismiss) var dismiss
    @ObservedObject var peopleVM: PeopleViewModel
    var personId: Int
    var name: String
    var image: String
    var country: String
    @State private var selectedCredit: CreditShow? = nil
    
    var body: some View {
        ZStack {
            ScrollView {
                personBackground
                
                personDetail
                    .offset(y: 20)
                    .padding(.bottom, 200)
                    .padding(.top)
            }
            .ignoresSafeArea()

            closeButton
        }
        .sheet(item: $selectedCredit, onDismiss: {
            
        }, content: { credit in
            if let url = credit.url {
                WebView(url: url)
            }
            
        })
        .task {
            await peopleVM.fetchPersonCredits(personId: personId)
        }
        .onDisappear {
            appBehavior.showDetail = false
        }
    }
    
    var personBackground: some View {
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
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .padding(20)
                .frame(maxWidth: 320)
        )
        .background(
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .fill(Color.black)
        )
        .mask(
            RoundedRectangle(cornerRadius: 0, style: .continuous)
        )
        .frame(height: 400)
    }
    
    var closeButton: some View {
        Button {
            appBehavior.showDetail.toggle()
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
    
    var personDetail: some View {
        VStack {
            Text(name)
                .font(.title.bold())
            
            Text(country)
                .font(.body)
                .foregroundColor(.secondary)

            VStack(alignment: .leading) {
                Text("Known For")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
            }
            .padding(.vertical)
            
           creditList
            
        }
    }
    
    var creditList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(peopleVM.personCredits) { personCredit in
                    MinimalCard(mediaTitle: personCredit.name ?? "Unknown", image: personCredit.image?.getValidImage() ?? "tvplaceholder", fontStyle: .headline)
                        .onTapGesture {
                            selectedCredit = personCredit
                        }
                }
            }
            .frame(height: 250)
            .padding(.horizontal, 20)
            Spacer()
        }
    }
}

struct PersonSheetView_Previews: PreviewProvider {
    static var previews: some View {
        PersonSheetView(peopleVM: PeopleViewModel(service: TvApiService()), personId: 1, name: "Brad Pitt", image: "tvplaceholder", country: "United States")
    }
}
