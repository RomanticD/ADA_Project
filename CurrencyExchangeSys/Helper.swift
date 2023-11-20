//
//  Helper.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/17.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, opacity: 1.0)
    }
}

var defaultRateData: [CurrencyExchangeData] = [
        CurrencyExchangeData(currency: "CNY", rate: [1.0, 0.127081, 1.080852, 20.752706]),
        CurrencyExchangeData(currency: "EUR", rate: [7.869022, 1.0, 8.505249, 163.303490]),
        CurrencyExchangeData(currency: "HKD", rate: [0.925196, 0.117574, 1.0, 19.200318]),
        CurrencyExchangeData(currency: "JPY", rate: [0.048186, 0.006124, 0.052082, 1]),
    ]

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

enum CurrencyDataMode {
    case latest
    case historic
}
