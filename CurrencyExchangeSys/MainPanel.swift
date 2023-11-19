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
        CurrencyExchangeData(currency: "CNY", rate: [1.0, 0.127081, 1.080852, 20.752706]),
        CurrencyExchangeData(currency: "EUR", rate: [7.869022, 1.0, 8.505249, 163.303490]),
        CurrencyExchangeData(currency: "HKD", rate: [0.925196, 0.117574, 1.0, 19.200318]),
        CurrencyExchangeData(currency: "JPY", rate: [0.048186, 0.006124, 0.052082, 1]),
    ]
    @State var animated : Bool = false;
    @State var selectedCurrency : [String] = []
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                CurrencyExchangeGraphView(rateData: sampleData, selectedCurrency: $selectedCurrency, animated: $animated)
                 
                OperationPanel(animated: $animated, selectedCurrency: $selectedCurrency)
                
            }
            .ignoresSafeArea(.all, edges: .all)
            .frame(width: (screen!.width / 1.8), height: (screen!.height / 1.8))
            .navigationTitle("Get Arbitrage Cycle")
            
            Spacer()
        }
        .padding()
        .background(content: {
            LinearGradient(
                colors: [.mint, .blue, .indigo],
                startPoint: .leading,
                endPoint: .trailing
            )
            .opacity(0.2)
        })
    }
}

#Preview {
    MainPanel()
        .frame(width: 1000, height: 400)
}
