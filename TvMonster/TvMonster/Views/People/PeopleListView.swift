//
//  PeopleListView.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import SwiftUI

struct PeopleListView: View {
    @EnvironmentObject var appBehavior: AppBehavior
    @ObservedObject var peopleVM: PeopleViewModel
    @Namespace var namespace
    @State private var selectedPerson: Person?
    @State private var showStatusBar = true
    @State private var isShowingDetail = false
    @State private var show = false
    
    var body: some View {
        
        
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 4) {
                    Text("People")
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                        spacing: 20
                    ) {
                        
                        ForEach(peopleVM.people) { item in
                            
                            VStack {
                                MinimalCard(mediaTitle: item.name, image: item.image?.getValidImage() ?? "")
                                    .onTapGesture {
                                        withAnimation(.openCard) {
                                            show.toggle()
                                            appBehavior.showDetail.toggle()
                                            showStatusBar = false
                                            selectedPerson = item
                                        }
                                    }
                            }
                            
                        }
                        
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                }
                
                
            }
            
        }
        .statusBar(hidden: !showStatusBar)
        .onChange(of: show) { newValue in
            withAnimation(.closeCard) {
                if newValue {
                    showStatusBar = false
                } else {
                    showStatusBar = true
                }
            }
        }
        .sheet(item: $selectedPerson) {
            
        } content: { person in
            PersonSheetView(peopleVM: peopleVM,
                            personId: person.id,
                            name: person.name,
                            image: person.image?.getValidImage() ?? "tvplaceholder",
                            country: person.country?.name ?? "")
        }
        
    }
}

struct PeopleListView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleListView(peopleVM: PeopleViewModel(service: TvApiService()))
    }
}
