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
    @Binding var rateData : [CurrencyExchangeData]
    @Binding var ratePathResultSet : [Double]
    @State var matrix : [[Double]] = []
    @State var hasArbitrageOpportunity : Bool = false
    @State var isButtonClicked : Bool = false
    @State var arbitrageCyclePath : [Int] = []
    var screen = NSScreen.main?.visibleFrame
    
    var body: some View {
        VStack{
            Button(action: {
                isButtonClicked = true
                hasArbitrageOpportunity.toggle()
                
                animated = false
                
                withAnimation (.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.5)) {
                    animated.toggle()
                }
                
                matrix = exchangeRateDataToMatrix(data: rateData.sorted(by: {$0.currency < $1.currency}))
                
                ratePathResultSet = [0.127081, 19.200318, 0.052082]
            
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
                ForEach(0..<matrix.count, id: \.self) { row in
                    HStack {
                        ForEach(0..<matrix[row].count, id: \.self) { col in
                            Text(String(format: "%.6f", matrix[row][col]))
                                .padding(5)
                                .frame(width: 100)
                                .border(Color.gray)
                                .transition(.scale)
                                
                        }
                    }
                }
            }
            .frame(height: 200)
            
            if (isButtonClicked){
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
                        .transition(.scale.combined(with: .slide))
                        .foregroundStyle(hasArbitrageOpportunity ? Color.green : Color.red)
                        .font(.largeTitle)
                }
                .animation(.default, value: animated)
            }
        
            Spacer()
        }
        .frame(width: (screen!.width / 1.5) / 2)
    }
}

#Preview {
    OperationPanel(animated: .constant(false), selectedCurrency: .constant([]), rateData: .constant(defaultRateData), ratePathResultSet: .constant([0.127081, 19.200318]))
}
