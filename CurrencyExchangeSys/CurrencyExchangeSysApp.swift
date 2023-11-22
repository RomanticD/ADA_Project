//
//  CurrencyExchangeSysApp.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/17.
//

import SwiftUI

@main
struct CurrencyExchangeSysApp: App {
    @StateObject private var appSetting = AppSetting()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appSetting)
        }
    }
}
