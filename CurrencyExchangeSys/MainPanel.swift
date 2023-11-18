//
//  MainPanel.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/17.
//

import SwiftUI

struct MainPanel: View {
    var screen = NSScreen.main?.visibleFrame
    let sampleData: [CurrencyExchangeData] = [
        CurrencyExchangeData(currency: "USD", rate: [1.0, 0.85, 0.74, 1.12]),
        CurrencyExchangeData(currency: "EUR", rate: [1.18, 1.0, 0.87, 1.31]),
        CurrencyExchangeData(currency: "GBP", rate: [1.35, 1.16, 1.0, 1.51]),
        CurrencyExchangeData(currency: "JPY", rate: [0.0089, 0.0077, 0.0067, 1]),
    ]
    
    var body: some View {
        VStack {
            HStack {
                CurrencyExchangeGraphView(rateData: sampleData)
                
                Text("Result")
                
                Spacer()
            }
            .ignoresSafeArea(.all, edges: .all)
            .frame(width: (screen!.width / 1.8), height: (screen!.height / 1.8))
            .navigationTitle("Get Arbitrage Cycle")
        }
        .padding()
    }
}

#Preview {
    MainPanel()
        .frame(width: 500, height: 300)
}
