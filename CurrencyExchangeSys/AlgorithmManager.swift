//
//  AlgorithmManager.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/19.
//

import Foundation


internal func exchangeRateDataToMatrix(data: [CurrencyExchangeData]) -> [[Double]] {
    var matrix: [[Double]] = []

    for currencyData in data {
        matrix.append(currencyData.rate)
    }

    print(matrix)
    
    return matrix
}

