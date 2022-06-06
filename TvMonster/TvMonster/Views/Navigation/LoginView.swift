//
//  LoginView.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @EnvironmentObject var appBehavior: AppBehavior
    @ObservedObject var authService: AuthenticationService
    @State private var pin: String = ""
    @State private var repeatedPin: String = ""
    @State private var isTouchIdEnabled: Bool = false
    @State private var isShowingView: Bool = false
    
    @Binding var isShowingLog: Bool
    
    func setNewPin() {
        if (pin == repeatedPin) && !pin.isEmpty {
            
            self.authService.updateStoredPin(self.pin)
            appBehavior.authReason = .login
            self.isShowingLog = false
        }
    }
    
    func loginPin() {
        if self.authService.validatePin(pin) {
            self.isShowingLog = false
        }
    }
    
    func handlePinLogin() {
        if appBehavior.authReason == .newPin {
            setNewPin()
        } else if appBehavior.authReason == .login {
            loginPin()
        }
    }
    
    func getTouchIdValue() -> Bool {
        return UserDefaults.standard.bool(forKey: "istouchidenabled")
    }
    
    func signInWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to sign in"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { authenticated, error in
                    
                    DispatchQueue.main.async {
                        
                        if authenticated {
                            self.isShowingLog = false
                        } else {
                            if let errorString = error?.localizedDescription {
                                print("Error in biometric policy evaluation: \(errorString)")
                            }
                            
                            self.isTouchIdEnabled = true
                        }
                        
                    }
                }
            
        } else {
            if let errorString = error?.localizedDescription {
                print("Error in biometric policy evaluation: \(errorString)")
            }
            
            isTouchIdEnabled = true
        }
    }
    
    var body: some View {
        
        ZStack {
            
            GeometryReader { proxy in
                
                Image("posters")
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, alignment: .center)
                    .ignoresSafeArea()
                    .overlay(
                    
                        VStack(spacing: 20) {
                            HStack {
                                Text(appBehavior.authReason == .login ? "Sign In" : "New Pin")
                                    .font(.system(.title, design: .rounded))
                                    .bold()
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            if isTouchIdEnabled {
                                
                                Image(systemName: "touchid")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.white)
                                
                            } else {
                                pinForm
                            }
                            
                            Button {
                                
                                if isTouchIdEnabled {
                                    signInWithBiometrics()
                                } else {
                                    handlePinLogin()
                                }

                            } label: {
                                Text(appBehavior.authReason == .login ? "Sign In" : "Done")
                            }
                            .padding(.horizontal)
                            .buttonStyle(TButtontyle(buttonStyle: .secondary))

                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.theme.green)
                        )
                        .padding(.horizontal)
                        .shadow(color: Color.theme.green.opacity(0.4), radius: 5, x: 0, y: 4)
                            .frame(width: 400)
                        
                    )
                    .opacity(isShowingView ? 1 : 0)
                
            }
        }
        .onAppear {
            
            if getTouchIdValue() {
                isTouchIdEnabled = true
            }
            
            withAnimation(.easeIn) {
                isShowingView = true
            }
            
        }
        
    }
    
    var pinForm: some View {
        VStack(spacing: 25) {
            HStack {
                Image(systemName: "key")
                    .padding(.horizontal)
                    .foregroundColor(Color.white)

                SecureField("Pin number", text: $pin)
                    .padding(.vertical)
                    .textContentType(.password)
                    .keyboardType(.numberPad)
            }
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.theme.darkGreen)
            )


            if appBehavior.authReason == .newPin {
                
                HStack {
                    Image(systemName: "key")
                        .padding(.horizontal)
                        .foregroundColor(Color.white)

                    SecureField("Repeat pin", text: $repeatedPin)
                        .padding(.vertical)
                        .textContentType(.password)
                        .keyboardType(.numberPad)
                }
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.theme.darkGreen)
                )
                
            }
        }
        .padding(.vertical)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authService: AuthenticationService(), isShowingLog: .constant(true))
    }
}
