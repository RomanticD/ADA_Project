//
//  MainPanel.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/17.
//

import SwiftUI

struct MainPanel: View {
    var screen = NSScreen.main?.visibleFrame
    @State var sampleData: [CurrencyExchangeData] = defaultRateData
    @State var animated : Bool = false;
    @State var selectedCurrency : [String] = []
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                CurrencyExchangeGraphView(rateData: $sampleData, selectedCurrency: $selectedCurrency, animated: $animated)
                 
                OperationPanel(animated: $animated, selectedCurrency: $selectedCurrency, rateData: $sampleData)
            }
            .ignoresSafeArea(.all, edges: .all)
            .frame(width: (screen!.width / 1.5), height: (screen!.height / 1.5))
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
