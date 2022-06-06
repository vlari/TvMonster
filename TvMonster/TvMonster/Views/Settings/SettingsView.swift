//
//  SettingsView.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import SwiftUI
import LocalAuthentication

struct SettingsView: View {
    @EnvironmentObject var appBehavior: AppBehavior
    @Binding var isToushIdEnabled: Bool
    
    func getBiometricType() -> Bool {
        let context = LAContext()
        
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .faceID:
            return true
        case .touchID:
            return false
        case .none:
            return false
        @unknown default:
            return false
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                Text("Settings")
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                VStack {
                    settingsOptions
                    
                    Button {
                        appBehavior.authReason = .login
                        appBehavior.isShowingLog = true
                    } label: {
                        Text("Log out")
                            .font(.headline)
                    }
                    .foregroundColor(Color.theme.green)
                    .buttonStyle(TTapButtontyle())
                    .padding(.top)
                }   
            }
            
        }
        
    }
    
    var settingsOptions: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Change Pin")
                    .font(.headline.bold())
                    .foregroundColor(Color.black.opacity(0.6))
                
                Spacer()
                
                Button {
                    appBehavior.authReason = .newPin
                    appBehavior.isShowingLog = true
                    
                } label: {
                    Image(systemName: "ellipsis.rectangle")
                        .font(.title)
                }
                .foregroundColor(Color.theme.green)
                .buttonStyle(TTapButtontyle())
            }
            .padding(.vertical, 3)
            
            HStack {
                Text("Use Tuch ID")
                    .font(.headline.bold())
                    .foregroundColor(Color.black.opacity(0.6))
                
                Spacer()
                
                Toggle("", isOn: $isToushIdEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: Color.theme.green))
            }
            .padding(.vertical, 3)
            // Aditional option to disable this setting
            //.opacity(getBiometricType() ? 1 : 0)
            
        }
        .padding()
        .padding(.horizontal)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isToushIdEnabled: .constant(false))
    }
}
