//
//  SettingView.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/22.
//

import SwiftUI

struct SettingPanel: View {
    @State private var apiKey: String = ""
    @State private var apiKeySaved = false
    @State private var apiKeyIsMissing = false
    @EnvironmentObject var appsettings: AppSetting
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.green, .cyan, .cyan ,.indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                        .opacity(0.3)
            
            VStack(spacing: 20) {
                Spacer()
                
                HStack {
                    Text("Set Your free currecy API key")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 50, weight: .heavy))
                        .bold()
                        .tracking(0.5)
                        .overlay {
                            LinearGradient(
                                colors: [.blue, .purple, .indigo],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask(
                                Text("Set Your free currecy API key")
                                    .font(.system(size: 50, weight: .heavy))
                                    .multilineTextAlignment(.center)
                                    .tracking(0.5)
                                    .bold()                     )
                    }
                }
                .padding(.vertical)
                
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
                }
                .alert(isPresented: $apiKeySaved) {
                    Alert(title: Text("API Key Updated"), message: Text("Your API key has been saved"), dismissButton: .default(Text("OK")))
                }

                HStack (spacing: 0){
                    Text("You can get your free api key")
                        .foregroundStyle(.secondary)
                    
                    Link("here", destination: URL(string: "https://app.freecurrencyapi.com/")!)
                        .padding(.leading, 3)
                }
                .alert(isPresented: $apiKeyIsMissing) {
                    Alert(
                        title: Text("API Key Missing"),
                        message: Text("Please enter your API key."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Spacer()
            }
            .navigationTitle("Setting")
            .ignoresSafeArea()
            .padding()
        }
        .onAppear {
            checkForAPIKey()
        }
    }
    
    private func checkForAPIKey() {
        if appsettings.apiKey.isEmpty{
            apiKeyIsMissing = true
        }
    }
    
    private func saveAPIKey() {
        if apiKey != ""{
            appsettings.apiKey = apiKey
            apiKeySaved = true
        }
    }
}

//#Preview {
//    SettingPanel()
//}
