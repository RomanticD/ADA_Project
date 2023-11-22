//
//  ContentView.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/17.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appsettings: AppSetting
    
    var body: some View {
        NavigationSplitView {
            List(0 ..< 3) { item in
                if (item == 0){
                    NavigationLink {
                        MainPanel()
                            .environmentObject(appsettings)
                    } label: {
                        Image(systemName: "wand.and.stars")
                            .foregroundStyle(.indigo)
                        Text("Get start")
                    }
                }
                
                if (item == 1){
                    NavigationLink {
                        WelcomePage()
                    } label: {
                        Image(systemName: "globe.asia.australia.fill")
                            .foregroundStyle(.indigo)
                        Text("Welcome")
                    }
                }
                
                if (item == 2){
                    NavigationLink {
                        SettingPanel()
                            .environmentObject(appsettings)
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(.indigo)
                        Text("Setting")
                    }
                }
            }
            .tint(.indigo)
        } detail: {
            WelcomePage()
        }
    }
}

#Preview {
    ContentView()
}
