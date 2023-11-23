//
//  CurrencyExchangeData.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/17.
//

import Foundation

struct CurrencyExchangeData : Identifiable, Equatable {
    let currency: String
    let rate: [Double]
    let id = UUID()
}
