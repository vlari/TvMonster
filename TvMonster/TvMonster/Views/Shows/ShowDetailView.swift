//
//  ShowDetailView.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI
import Kingfisher

struct ShowDetailView: View {
    @EnvironmentObject var model: AppBehavior
    @ObservedObject var vm: ShowsViewModel
    @Binding var show: Bool
    
    var namespace: Namespace.ID
    var selectedShow: Show?
    var episodes: [Int : [Episode]]
    
    @State private var appear = [false, false, false]
    @State private var viewState: CGSize = .zero
    @State private var isDraggable = true
    @State private var showSection = false
    @State private var selectedIndex = 0
    @State private var selectedEpisode: Episode? = nil
    @State private var isFavorite: Bool = false
    
    var body: some View {
     
        ZStack {
            ScrollView {
                detailBackground
                
                VStack {
                    Text(selectedShow?.name ?? "")
                        .font(.title)
                    
                    Text(FormatterManager.shared.getYear(from: selectedShow?.premiered))
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                HStack {
                    Rating(ratingValue: FormatterManager.shared.getRating(rating: selectedShow?.rating?.average))
                        .matchedGeometryEffect(id: "stars\(selectedShow?.id ?? 1)", in: namespace)
                    
                    Spacer()
                    
                    Button {
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                            .font(.title)
                            .foregroundColor(Color.theme.green)
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(TTapButtontyle())
                    
                }
                .font(.title2)
                .padding()
                .padding(.horizontal)
                .padding(.bottom)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedShow?.genres ?? [String](), id: \.self) { genre in
                            VStack {
                                Text(genre)
                                    .padding()
                            }
                            .foregroundColor(.white)
                            .frame(height: 10)
                            .padding(.vertical)
                            .background(Color.theme.green)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 4)
                    }
                    .padding(.horizontal)
                }
                .matchedGeometryEffect(id: "genre\(selectedShow?.id ?? 1)", in: namespace)
                
                ParagraphView(descriptionText: selectedShow?.summary?.stripHTML ?? "Summary not provided.")
                    .padding(.vertical)
                
                HStack {
                    Text("Whatch it at")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(Color.black)
                    
                    Text(" \(selectedShow?.schedule?.time ?? "-")")
                        .foregroundColor(Color.black)
                    Spacer()
                }
                .padding(.vertical, 3)
                .padding(.horizontal)
                
                HStack {
                    Text("On")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(Color.black)
                    
                    Text(" \(selectedShow?.schedule?.days.joined(separator: ",") ?? "" )")
                        .foregroundColor(Color.black)
                    
                    Spacer()
                }
                .padding(.vertical, 3)
                .padding(.horizontal)
                
                
                VStack(alignment: .leading) {
                    Text("Episodes")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                }
                .padding(.vertical)
                .padding(.top)
                
                ForEach(Array(vm.episodes.keys.sorted()), id: \.self) { key in
                    VStack(alignment: .leading) {
                        Text("Season \(key)")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(Color.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                    }
                    
                    ForEach(vm.episodes[key]!, id: \.self) { episode in
                        EpisodeCard(name: episode.name ?? "Not provided",
                                    episodeNumber: episode.number)
                            .onTapGesture {
                                selectedEpisode = episode
                            }
                    }
                }
                
            }
            .coordinateSpace(name: "scroll")
            .background(Color.white)
            .mask(RoundedRectangle(cornerRadius: viewState.width / 3, style: .continuous))
            .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 10)
            .scaleEffect(viewState.width / -500 + 1)
            .background(.black.opacity(viewState.width / 500))
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
            
            closeButton
        }
        .task {
            await vm.fetchEpisodes(showId: selectedShow?.id ?? 1)
        }
        .onAppear {
            fadeInAnimations()
            
            if let objectId = selectedShow?.savedId {
                isFavorite = vm.isFavoriteShow(objectId: objectId)
            }
        }
        .onDisappear(perform: {
            
            if isFavorite {
                vm.saveFavorite(show: selectedShow)
            } else {
                vm.deleteFavorite(objectId: selectedShow?.savedId)
            }
            
        })
        
        .onChange(of: show) { newValue in
            fadeOutAnimations()
        }
        .sheet(item: $selectedEpisode) { episode in
            EpisodeSheetView(name: episode.name ?? "Name not provided.",
                             season: episode.season,
                             number: episode.number,
                             summary: episode.summary?.stripHTML ?? "Summary not provided.",
                             image: episode.image?.getValidImage() ?? "tvplaceholder")
        }
        
    }
    
    var detailBackground: some View {
        GeometryReader { proxy in
            let scrollY = proxy.frame(in: .named("scroll")).minY
            
            VStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: scrollY > 0 ? 500 + scrollY : 500)
            .foregroundStyle(.black)
            .background(
                KFImage.url(URL(string: selectedShow?.image?.medium ?? ""))
                    .placeholder {
                        Image("tvplaceholder")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .padding(20)
                    .frame(maxWidth: 320)
                    .matchedGeometryEffect(id: "image\(selectedShow?.id ?? 1)", in: namespace)
                    .offset(y: scrollY > 0 ? scrollY * -0.8 : 0)
            )
            .background(
                KFImage.url(URL(string: selectedShow?.image?.medium ?? ""))
                    .placeholder {
                        Image("tvplaceholder")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .matchedGeometryEffect(id: "background\(selectedShow?.id ?? 1)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
                    .scaleEffect(scrollY > 0 ? scrollY / 1000 + 1 : 1)
                    .blur(radius: 4)
            )
            .mask(
                RoundedRectangle(cornerRadius: appear[0] ? 0 : 30, style: .continuous)
                    .matchedGeometryEffect(id: "mask\(selectedShow?.id ?? 1)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
            )
        }
        .frame(height: 500)
    }
    
    var closeButton: some View {
        Button {
            withAnimation(.closeCard) {
                show.toggle()
                model.showDetail.toggle()
            }
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
    
    func fadeInAnimations() {
        withAnimation(.easeOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.4)) {
            appear[1] = true
        }
        withAnimation(.easeOut.delay(0.5)) {
            appear[2] = true
        }
    }
    
    func fadeOutAnimations() {
        appear[0] = false
        appear[1] = false
        appear[2] = false
    }
}

struct ShowDetailView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        ShowDetailView(vm: ShowsViewModel(service: TvApiService(),
                                          dataService: TvDataService(dataManager: DataManager.shared)),
                       show: .constant(true), namespace: namespace,
                       episodes: [Int : [Episode]]())
    }
}
