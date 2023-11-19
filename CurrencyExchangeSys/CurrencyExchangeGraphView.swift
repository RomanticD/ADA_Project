//
//  CurrencyExchangeGraphView.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/17.
//

import SwiftUI

struct CurrencyExchangeGraphView: View {
    @State var rateData : [CurrencyExchangeData]
    @State var ratePathResultSet : [Double] = [0.127081, 19.200318]
    @State var isRefreshButtonClicked : Bool = false
    @Binding var selectedCurrency : [String]
    @Binding var animated : Bool
    @State var showAlert : Bool = false
    var screen = NSScreen.main?.visibleFrame
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "dollarsign")
                    .bold()
                    .font(.largeTitle)
                    .shadow(radius: 1, x: 1, y: 1)
                    .foregroundStyle(.purple)
                    .symbolEffect(
                        .bounce.up.byLayer,
                        options: .speed(1.5),
                        value: animated
                    )
                
                Text("Exchange Rate")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .bold()
                    .tracking(0.5)
                    .shadow(radius: 1, x: 1, y: 1)
                    .overlay {
                        LinearGradient(
                            colors: [.purple, .blue, .indigo],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .mask(
                            Text("Exchange Rate")
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                                .tracking(0.5)
                                .bold()
                                .shadow(radius: 1, x: 1, y: 1)                        )
                    }
                
            }
            
            let sortedRateData = rateData.sorted(by: {$0.currency < $1.currency})
            
            Grid() {
                GridRow {
                    Text("From / To")
                        .bold()
                        .foregroundStyle(Color.secondary)
                    
                    ForEach(sortedRateData) { datum in
                        Text(datum.currency)
                            .bold()
                            .foregroundStyle(Color.secondary)
                    }
                }
                
                Divider()
                
                ForEach(sortedRateData) { datum in
                    GridRow {
                        Text(datum.currency)
                            .bold()
                            .foregroundStyle(Color.secondary)
                        
                        ForEach(datum.rate, id: \.self) { rate in
                            Text("\(rate)")
                                .modifier(CellModifier(data: rate, ratePathResultSet: ratePathResultSet, animated: $animated))
                        }
                    }
                    
                    Divider()
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.indigo.opacity(0.2))
                    .shadow(radius: 7, x: 5, y: 5)
            }
           
            VStack{
                HStack(alignment: .firstTextBaseline){
                    Image(systemName: "dot.circle.and.cursorarrow")
                        .bold()
                        .font(.largeTitle)
                        .foregroundStyle(.purple)
                        .shadow(radius: 1, x: 1, y: 1)
                        .symbolEffect(
                            .bounce.down.byLayer,
                            options: .speed(1.5),
                            value: selectedCurrency
                        )
                        
                    
                    Text("Select Currency")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .bold()
                        .tracking(0.5)
                        .shadow(radius: 1, x: 1, y: 1)
                        .overlay {
                            LinearGradient(
                                colors: [.purple, .blue, .indigo],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask(
                                Text("Select Currency")
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.center)
                                    .tracking(0.5)
                                    .bold()
                                    .shadow(radius: 1, x: 1, y: 1)
                            )
                        }
                }
                .padding(.top)
                
                createCurrencyTags()
                    .padding(.top, -10)
            }
        }
        .frame(width: (screen!.width / 1.8) / 2)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItemGroup {
                Button(action: {
                    isRefreshButtonClicked = false
                    
                    if (selectedCurrency.isEmpty){
                        showAlert.toggle()
                        return
                    }
                    
                    withAnimation {
                        isRefreshButtonClicked.toggle()
                    }
                    
                    rateData = []
                    
                    Task{
                        await fetchExchangeRatesForSelectedCurrencies(selectedCurrency: selectedCurrency)
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .bold()
                            .foregroundStyle(.primary)
                            .rotationEffect(.degrees(isRefreshButtonClicked ? 360 : 0))
                    
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("No Currency Selected"), message: Text("Please choose at least TWO currency"), dismissButton: .default(Text("Got it")))
                }
            }
        }
    }
    
    func fetchExchangeRatesForSelectedCurrencies(selectedCurrency : [String]) async {
        for baseCurrency in selectedCurrency {
            var currenciesToFetch = selectedCurrency
            currenciesToFetch.removeAll { $0 == baseCurrency }

            await fetchLatestExchangeRate(baseCurrency: baseCurrency, currencies: currenciesToFetch)
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
    
    private func fetchLatestExchangeRate(baseCurrency: String, currencies: [String]) async {
        let targetCurrencies = currencies.sorted(by: {$0 < $1}).joined(separator: "%2C")
        
        var exchangeRates: [String: Double] = [:]
        
        guard let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_puJRzjU6qLajkDBk2yo157HJGsu8P5u6qj92nGmx&currencies=\(targetCurrencies)&base_currency=\(baseCurrency)") else{
                print("Invalid URL")
            return
        }
        print("fetching exchange rate at: \(url)")
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(FetchedExchangeRate.self, from: data){
                exchangeRates = decodedResponse.data
                print("Successfully decoded!")
            }
            
            rateData.append(CurrencyExchangeData(currency: baseCurrency, rate: extractDoubleValues(from: exchangeRates, baseCurrency: baseCurrency)))
            
        } catch {
            print("Invalid response!" ,error)
        }
    }
    
    private func extractDoubleValues(from exchangeRates: [String: Double], baseCurrency: String) -> [Double] {
        var sortedValues = exchangeRates.sorted { $0.key < $1.key }.map { $0.value }
        
        if let index = selectedCurrency.sorted(by: { $0 < $1 }).firstIndex(of: baseCurrency){
            sortedValues.insert(1.0, at: index)
        }
       
        return sortedValues
    }

    private func generateRandomRates() -> [Double] {
        let randomMultiplier = Double.random(in: 0.5...1.5)

        let randomRates = (0..<4).map { _ in
            return Double.random(in: 0.01...2.0)
        }

        let adjustedRates = randomRates.map { $0 * randomMultiplier }
        return adjustedRates
    }
    
    @ViewBuilder
    private func createCurrencyTags() -> some View {
        let currencyCodes = ["USD", "EUR", "JPY", "GBP", "AUD", "HKD", "CNY", "NZD"]
        
        VStack {
            HStack {
                ForEach(currencyCodes.prefix(4), id: \.self) { currency in
                    CurrencyTag(currency: currency, selectedCurrency: $selectedCurrency)
                        .padding(.horizontal, 3)
                }
            }
            
            HStack {
                ForEach(currencyCodes.suffix(4), id: \.self) { currency in
                    CurrencyTag(currency: currency, selectedCurrency: $selectedCurrency)
                        .padding(.horizontal, 3)
                }
            }
            .padding(.top, 3)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.indigo.opacity(0.2))
                .shadow(radius: 7, x: 5, y: 5)
        }
    }

}

struct CellModifier: ViewModifier {
    let data: Double
    let ratePathResultSet: [Double]
    @Binding var animated : Bool

    func body(content: Content) -> some View {
        let rateContainedInResult = ratePathResultSet.contains(data)
        let isBoldAndColored : Bool  = rateContainedInResult && animated
        
        return content
            .bold(isBoldAndColored)
            .foregroundStyle(getTextColor(data: data, ratePathResultSet: ratePathResultSet, animated: animated))
    }
    
    private func getTextColor(data: Double, ratePathResultSet: [Double], animated: Bool) -> Color{
        let rateContainedInResult = ratePathResultSet.contains(data)
        let isBoldAndColored : Bool  = rateContainedInResult && animated
        
        if (data == 1.0){
            return Color.secondary
        }else{
            if (isBoldAndColored){
                return Color.indigo.opacity(0.8)
            }else{
                return Color.primary
            }
        }
    }
}

#Preview {
    CurrencyExchangeGraphView(rateData: [
        CurrencyExchangeData(currency: "CNY", rate: [1.0, 0.127081, 1.080852, 20.752706]),
        CurrencyExchangeData(currency: "EUR", rate: [7.869022, 1.0, 8.505249, 163.303490]),
        CurrencyExchangeData(currency: "HKD", rate: [0.925196, 0.117574, 1.0, 19.200318]),
        CurrencyExchangeData(currency: "JPY", rate: [0.048186, 0.006124, 0.052082, 1]),
    ], selectedCurrency: .constant(["CNY", "JPY"]), animated: .constant(false))
    .frame(width: 400, height: 500)
}
