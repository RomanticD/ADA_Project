//
//  CurrencyExchangeGraphView.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/17.
//

import SwiftUI

struct CurrencyExchangeGraphView: View {
    @Binding var rateData : [CurrencyExchangeData]
    @State private var ratePathResultSet : [Double] = [0.127081, 19.200318]
    @State private var isRefreshButtonClicked : Bool = false
    @State private var isFetchLatestButtonClicked : Bool = false
    @State private var isFetchHistoricButtonClicked : Bool = false
    @Binding var selectedCurrency : [String]
    @Binding var animated : Bool
    @State private var showAlert : Bool = false
    @State private var selectedDate = Date.now
    @State private var mode : CurrencyDataMode = .latest
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
                    
                    if (hasPanelModified()){
                        //after data was fetched
                        ForEach(selectedCurrency, id: \.self){ currency in
                            Text(currency)
                                .bold()
                                .foregroundStyle(Color.secondary)
                        }
                    } else {
                        //default one
                        ForEach(sortedRateData) { datum in
                            Text(datum.currency)
                                .bold()
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
                .frame(height: hasPanelModified() ? (300.0 / CGFloat((selectedCurrency.count + 1))) : 60)
                
                Divider()
                
                ForEach(sortedRateData) { datum in
                    GridRow {
                        Text(datum.currency)
                            .bold()
                            .foregroundStyle(Color.secondary)
                        
                        if (datum.rate.isEmpty){
                            ProgressView()
                        }else{
                            ForEach(datum.rate, id: \.self) { rate in
                                Text("\(rate)")
                                    .modifier(CellModifier(data: rate, ratePathResultSet: ratePathResultSet, animated: $animated))
                            }
                        }
                    }
                    .frame(height: hasPanelModified() ? (300.0 / CGFloat((selectedCurrency.count + 1))) : 60)
                    
                    Divider()
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.indigo.opacity(0.2))
                    .shadow(radius: 7, x: 5, y: 5)
            }
            
            Spacer(minLength: 0)
           
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
                .padding(.top, 20)
                
                createCurrencyTags()
                    .padding(.top, -10)
            }
    
            VStack {
                createRefreshButton(setMode: .latest, buttonText: "Get Latest Currency Rate", symbolName: "clock.badge.checkmark")
                
                createRefreshButton(setMode: .historic, buttonText: "Get Historic Currency Rate", symbolName: "clock.arrow.circlepath")
            }
            .padding(.top, 20)
        }
        .frame(width: (screen!.width / 1.5) / 2)
        .ignoresSafeArea()
    }
    
    private func hasPanelModified() -> Bool{
        return rateData.count != selectedCurrency.count && rateData != defaultRateData
    }
    
    private func correspondingClickedParameter(mode : CurrencyDataMode) -> Bool {
        switch mode {
        case .latest:
            return isFetchLatestButtonClicked
        case .historic:
            return isFetchHistoricButtonClicked
        }
    }
    
    
    @ViewBuilder
    private func createButtonContent(mode: CurrencyDataMode, symbolName: String, buttonText: String) -> some View {
        let isButtonClicked: Bool = correspondingClickedParameter(mode: mode)
        
        HStack {
            Image(systemName: symbolName)
                .padding(.trailing, 6)
                .font(.system(size: 20))
                .foregroundStyle(Color(hex: "2c3e50"))
                .symbolEffect(
                    .bounce.up.byLayer,
                    options: .speed(1.3).repeat(selectedCurrency.count + 1),
                    value: isButtonClicked
                )
            
            Text(buttonText)
                .frame(width: 170)
                .foregroundColor(Color(hex: "2a0845"))
                .padding()
                .lineLimit(1)
                .background(content: {
                    LinearGradient(
                        colors: [.mint, .blue, .indigo],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .opacity(0.3)
                })
                .frame(height: 30)
                .cornerRadius(15)
                .overlay(Capsule().stroke(Color(hex: "2c3e50").opacity(0.6), lineWidth: 1))
        }
    }

    @ViewBuilder
    private func createRefreshButton(setMode: CurrencyDataMode, buttonText: String, symbolName: String) -> some View {
        Button(action: {
            showAlert = false
            
            if (selectedCurrency.count < 2){
                showAlert.toggle()
                return
            }
            
            mode = setMode
            
            withAnimation {
                switch setMode {
                case .latest:
                    isFetchLatestButtonClicked.toggle()
                case .historic:
                    isFetchHistoricButtonClicked.toggle()
                }
            }
            
            rateData = []
            
            Task{
                await fetchLatestExchangeRatesForSelectedCurrencies(selectedCurrency: selectedCurrency, mode: mode)
                
                defaultRateData = rateData
            }
        }) {
            createButtonContent(mode: setMode, symbolName: symbolName, buttonText: buttonText)
        }
        .offset(x: -20)
        .padding(.vertical, 4)
        .buttonStyle(.plain)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("No Currency Selected"), message: Text("Please choose at least TWO currency"), dismissButton: .default(Text("Got it")))
        }
    }
    
    private func fetchLatestExchangeRatesForSelectedCurrencies(selectedCurrency : [String], mode: CurrencyDataMode) async {
        for baseCurrency in selectedCurrency {
            var currenciesToFetch = selectedCurrency
            currenciesToFetch.removeAll { $0 == baseCurrency }
            await fetchLatestExchangeRate(baseCurrency: baseCurrency, currencies: currenciesToFetch, mode: mode)
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
    
    private func fetchLatestExchangeRate(baseCurrency: String, currencies: [String], mode: CurrencyDataMode) async {
        let targetCurrencies = currencies.sorted(by: {$0 < $1}).joined(separator: "%2C")
        var exchangeRates: [String: Double] = [:]
        var url : URL
        
        switch mode {
            case .latest:
                guard let latestURL = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_puJRzjU6qLajkDBk2yo157HJGsu8P5u6qj92nGmx&currencies=\(targetCurrencies)&base_currency=\(baseCurrency)") else {
                    print("Invalid URL")
                    return
                }
                url = latestURL
            case .historic:
                guard let historicURL = URL(string: "https://api.freecurrencyapi.com/v1/historical?apikey=fca_live_puJRzjU6qLajkDBk2yo157HJGsu8P5u6qj92nGmx&currencies=\(targetCurrencies)&base_currency=\(baseCurrency)&date=\(generateDate())") else {
                    print("Invalid URL")
                    return
                }
                url = historicURL
            }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            switch mode {
            case .latest:
                if let decodedResponse = try? JSONDecoder().decode(FetchedLatestExchangeRate.self, from: data){
                    exchangeRates = decodedResponse.data
                    print("Successfully decoded!")
                }
            case .historic:
                if let decodedResponse = try? JSONDecoder().decode(FetchedHistoricalExchangeRate.self, from: data){
                    exchangeRates = decodedResponse.data.first?.value ?? [:]
                    print("Successfully decoded!")
                }
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

#Preview {
    CurrencyExchangeGraphView(rateData: .constant(defaultRateData), selectedCurrency: .constant(["CNY", "JPY"]), animated: .constant(false))
    .frame(width: 400, height: 500)
}
