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
    @State private var ratePathResultSet : [Double] = [0.127081, 19.200318]
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.green, .cyan, .cyan ,.indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                        .opacity(0.3)
            
            VStack {
                Spacer()
                
                HStack {
                    CurrencyExchangeGraphView(rateData: $sampleData, ratePathResultSet: $ratePathResultSet, selectedCurrency: $selectedCurrency, animated: $animated)
                     
                    OperationPanel(animated: $animated, selectedCurrency: $selectedCurrency, rateData: $sampleData, ratePathResultSet: $ratePathResultSet)
                }
                .ignoresSafeArea(.all, edges: .all)
                .frame(width: (screen!.width / 1.5), height: (screen!.height / 1.5))
                .navigationTitle("Get Arbitrage Cycle")
                
                Spacer()
            }
            .padding()
        }
        
    }
}

#Preview {
    MainPanel()
        .frame(width: 1000, height: 400)
}
