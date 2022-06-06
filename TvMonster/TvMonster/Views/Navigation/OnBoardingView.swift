//
//  OnBoardingView.swift
//  TvMonster
//
//  Created by Obed Garcia on 6/6/22.
//

import SwiftUI

struct OnBoardingView: View {
    @EnvironmentObject var appBehavior: AppBehavior
    @State private var onBoardingState: OnBoardingState = .loading
    @Binding var isFirstTimeUser: Bool
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            mainOnboarding
        }
        .onAppear {
            withAnimation(.spring().delay(0.4)) {
                onBoardingState = .firstScreen
            }
        }
        
    }
    
    var mainOnboarding: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("tvIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            
            Image("posters")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cardStyle(cornerRadius: 22)
                .padding(.horizontal)
                .opacity(onBoardingState == .loading ? 0 : 1)
            
            Text("Enjoy")
                .font(.system(.title, design: .rounded))
                .bold()
                .foregroundColor(Color.theme.green)
                .opacity(onBoardingState == .loading ? 0 : 1)

            Text("Know more about all your favorite shows in one place")
                .font(.body)
                .foregroundColor(Color.theme.green)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .opacity(onBoardingState == .loading ? 0 : 1)
            
            Spacer()
                
            Button {

                appBehavior.authReason = .newPin
                isFirstTimeUser.toggle()
                
            } label: {
                Text("Get Started")
            }
            .buttonStyle(TButtontyle())
            .opacity(onBoardingState == .loading ? 0 : 1)
            
        }
        .padding()
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(isFirstTimeUser: .constant(true))
    }
}

// Handle onboarding state and multiple screen
enum OnBoardingState {
    case loading
    case firstScreen
    case secondScreen
}
