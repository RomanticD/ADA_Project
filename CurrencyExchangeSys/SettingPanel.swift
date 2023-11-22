//
//  SettingView.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/22.
//

import SwiftUI

struct SettingPanel: View {
    @State private var apiKey: String = ""
    @State private var showAlert = false
    @EnvironmentObject var appsettings: AppSetting
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Set Your free currecy API key")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .bold()
                .tracking(0.5)
                .overlay {
                    LinearGradient(
                        colors: [.mint, .green, .yellow],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Text("Set Your free currecy API key")
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .tracking(0.5)
                            .bold()                     )
                }
            
            HStack {
                Text("API Key:")
                    .font(.headline)
                
                TextField("Enter your API key here", text: $apiKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 500)
                
                Button("Save", action: {
                    saveAPIKey()
                })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("API Key Updated"), message: Text("Your API key has been saved"), dismissButton: .default(Text("OK")))
                }
            }

            HStack (spacing: 0){
                Text("You can get your free api key")
                
                Link("here", destination: URL(string: "https://app.freecurrencyapi.com/")!)
                    .padding(.leading, 3)
            }
            
            Spacer()
        }
        .navigationTitle("Setting")
        .ignoresSafeArea()
        .padding()
    }
    
    func saveAPIKey() {
        if apiKey != ""{
            appsettings.apiKey = apiKey
            showAlert = true
        }
    }
}

#Preview {
    SettingPanel()
}
