//
//  OperationPanel.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/18.
//

import SwiftUI

struct OperationPanel: View {
    @Binding var animated : Bool
    @Binding var selectedCurrency : [String]
    @State private var currencyArrayAfterButtonClicked : [String] = []
    @State private var cycleDisplay = ""
    @Binding var rateData : [CurrencyExchangeData]
    @Binding var ratePathResultSet : [Double]
    @State var matrix : [[Double]] = []
    @State var hasArbitrageOpportunity : Bool = false
    @State var isButtonClicked : Bool = false
    @State var arbitrageCyclePath : [Int] = []
    @State var resultRatio : Double = 0.0
    var screen = NSScreen.main?.visibleFrame
    
    var body: some View {
        VStack{
            Button(action: {
                isButtonClicked = true
                
                animated = false
                
                withAnimation (.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.5)) {
                    animated.toggle()
                }
                
                matrix = exchangeRateDataToMatrix(data: rateData.sorted(by: {$0.currency < $1.currency}))
                
                let arbitageInfo = findArbitrageChanceInfo(matrix: matrix)
                
                hasArbitrageOpportunity = arbitageInfo.hasArbitrageChance
                
                if hasArbitrageOpportunity{
                    arbitrageCyclePath = arbitageInfo.vertexPath
                    arbitrageCyclePath.append(arbitrageCyclePath[0])
                }
                
                ratePathResultSet = arbitageInfo.resultRateSet
                resultRatio = arbitageInfo.result
                currencyArrayAfterButtonClicked = selectedCurrency.sorted(by: {$0 < $1})
                cycleDisplay = displayArbitageCycle(currencyArray: selectedCurrency.sorted(by: {$0 < $1}), vertexVisited: arbitrageCyclePath)
            }, label: {
                HStack {
                    Image(systemName: "point.forward.to.point.capsulepath.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(hex: "2c3e50"))
                        .symbolEffect(
                            .bounce.up.byLayer,
                            options: .speed(1.3),
                            value: animated
                        )
                        .padding(.leading, 10)
                    
                    Text("Detect Arbitrage Chance Now")
                        .bold()
                        .frame(width: 200)
                        .foregroundColor(Color(hex: "2a0845"))
                        .padding()
                        .lineLimit(1)
                }
                .background(content: {
                    LinearGradient(
                        colors: [.purple, .mint, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .opacity(0.3)
                })
                .frame(height: 30)
                .cornerRadius(15)
                .overlay(Capsule().stroke(Color(hex: "2c3e50").opacity(0.6), lineWidth: 1))
            })
            .buttonStyle(.plain)
            
            VStack{
                Text(isButtonClicked ? "The matrix passed into the algorithm: " : "Click the button above to continue")
                    .font(.subheadline)
                    .padding(.top)
                    .foregroundColor(.secondary)
                    .transition(.slide)
                
                if (isButtonClicked){
                    VStack {
                        ForEach(0..<matrix.count, id: \.self) { row in
                            HStack {
                                ForEach(0..<matrix[row].count, id: \.self) { col in
                                    Text(String(format: "%.6f", matrix[row][col]))
                                        .padding(5)
                                        .frame(width: 400 / CGFloat(matrix.count))
                                        .border(Color(hex: "2c3e50").opacity(0.6), width: 2)
                                        .transition(.scale)
                                        
                                }
                            }
                        }
                    }
                    .frame(height: 200)
                }else{
                    ProgressView()
                        .padding(5)
                        .frame(height: 200)
                }
            }
            
            if (true){
                Image(systemName: "arrowshape.down.fill")
                    .padding(.vertical)
                    .font(.system(size: 50))
                    .bold()
                    .foregroundStyle(hasArbitrageOpportunity ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
                    .transition(.symbolEffect(.appear, options: .speed(0.5)))
                    .symbolEffect(
                        .bounce.up.byLayer,
                        value: animated
                    )
            }
            
            if (true){
                HStack {
                    Image(systemName: hasArbitrageOpportunity ? "checkmark.square" : "xmark.square")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundStyle(hasArbitrageOpportunity ? Color.green : Color.red)
                        .symbolEffect(
                            .bounce.up.byLayer,
                            options: .speed(0.5),
                            value: animated
                        )
                        .contentTransition(.symbolEffect(.replace, options: .speed(0.5)))
                    
                    Text(hasArbitrageOpportunity ? "Arbitrage Opportunities Discoverd 🤩": "No Arbitrage Opportunities Found 💔")
                        .bold()
                        .transition(.scale.combined(with: .slide).combined(with: .opacity))
                        .foregroundStyle(hasArbitrageOpportunity ? Color.green : Color.red)
                        .font(.largeTitle)
                }
                .animation(.default, value: animated)
            }
            
            if isButtonClicked && !currencyArrayAfterButtonClicked.isEmpty {
                Text(cycleDisplay)
                .lineSpacing(5)
                .font(.title2)
                .padding(.top)
                .fontWeight(.semibold)
                .frame(height: 200)
            } else if isButtonClicked{
                Text("""
                    1. Change from EUR to HKD
                    2. Change from HKD to CNY
                    3. Change from CNY to EUR
                    """)
                .lineSpacing(5)
                .font(.title2)
                .padding(.top)
                .fontWeight(.semibold)
                .frame(height: 200)
            }
            
            if isButtonClicked{
                let formattedResult = String(format: "%.15f", resultRatio)
                Text("result/original = " + formattedResult)
                
                let profitInfo = getProfitInfo(ratioAfterExchange: resultRatio)
                
                Text(profitInfo.message)
                    .font(.system(size: 14, design: .rounded))
                    .padding(.vertical)
                    .fontWeight(.light)
                    .transition(.slide.combined(with: .opacity))
                    .bold(getProfitInfoTextStyle(mode: profitInfo.displayMode).bold)
                    .foregroundStyle(getProfitInfoTextStyle(mode: profitInfo.displayMode).color)
            }
        
            Spacer()
        }
        .onAppear(perform: {
        })
        .frame(width: (screen!.width / 1.5) / 2)
    }
    
    private func getProfitInfoTextStyle(mode : DisplayMode) -> (color : Color, bold : Bool){
        switch mode{
        case .errorRange:
            return (Color.yellow, true)
        case .found:
            return (Color.green, true)
        case .notFound:
            return (Color.red, true)
        }
    }
}

//#Preview {
//    OperationPanel(animated: .constant(false), selectedCurrency: .constant([]), rateData: .constant(defaultRateData), ratePathResultSet: .constant([0.127081, 19.200318]))
//        .frame(width: 400, height: 600)
//}
