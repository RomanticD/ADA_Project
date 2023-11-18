//
//  ContentView.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            List(0 ..< 2) { item in
                if (item == 0){
                    NavigationLink {
                        MainPanel()
                    } label: {
                        Image(systemName: "wand.and.stars")
                            .foregroundStyle(.blue)
                        Text("Get start")
                    }
                }
                
                if (item == 1){
                    NavigationLink {
                        WelcomePage()
                    } label: {
                        Image(systemName: "globe.asia.australia.fill")
                            .foregroundStyle(.blue)
                        Text("Welcome")
                    }
                }
            }
        } detail: {    
            WelcomePage()
        }
    }
}

#Preview {
    ContentView()
}
