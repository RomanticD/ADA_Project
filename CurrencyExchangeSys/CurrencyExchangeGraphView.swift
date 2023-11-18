//
//  CurrencyExchangeGraphView.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/17.
//

import SwiftUI

struct CurrencyExchangeGraphView: View {
    @State var rateData : [CurrencyExchangeData]
    
    var body: some View {
        VStack {
            Text("Exchange rate: ")
                .bold()
                .font(.system(size: 13))
            
            Table(of: CurrencyExchangeData.self) {
                TableColumn("From / To") { data in
                    Text(data.currency)
                }
                TableColumn("USD") { data in
                    Text("\(data.rate[0])")
                }
                TableColumn("EUR") { data in
                    Text("\(data.rate[1])")
                }
                TableColumn("GBP") { data in
                    Text("\(data.rate[2])")
                }
                TableColumn("JPY") { data in
                    Text("\(data.rate[3])")
                }
            } rows: {
                ForEach(rateData) { datum in
                    TableRow(datum)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button(action: {
                    generateData()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .bold()
                            .foregroundStyle(.primary)
                    
                    }
                }
            }
        }
    }
    
    private func generateData() {
        rateData = [
            CurrencyExchangeData(currency: "USD", rate: generateRandomRates()),
            CurrencyExchangeData(currency: "EUR", rate: generateRandomRates()),
            CurrencyExchangeData(currency: "GBP", rate: generateRandomRates()),
            CurrencyExchangeData(currency: "JPY", rate: generateRandomRates())
        ]
    }

    private func generateRandomRates() -> [Double] {
        let randomMultiplier = Double.random(in: 0.5...1.5)

        let randomRates = (0..<4).map { _ in
            return Double.random(in: 0.01...2.0)
        }

        let adjustedRates = randomRates.map { $0 * randomMultiplier }
        return adjustedRates
    }

}


#Preview {
    CurrencyExchangeGraphView(rateData: [
        CurrencyExchangeData(currency: "USD", rate: [1.0, 0.85, 0.74, 1.12]),
        CurrencyExchangeData(currency: "EUR", rate: [1.18, 1.0, 0.87, 1.31]),
        CurrencyExchangeData(currency: "GBP", rate: [1.35, 1.16, 1.0, 1.51]),
        CurrencyExchangeData(currency: "JPY", rate: [0.0089, 0.0077, 0.0067, 1]),
    ])
    .frame(width: 500, height: 300)
}
