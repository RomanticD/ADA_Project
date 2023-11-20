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
        print("Matrix in progress:  \(matrix)")
    }

    print("Final matrix: \(matrix)")
    
    return matrix
}

internal func hasArbitrage(matrix: [[Double]]) -> (Bool, [Int]) {
    let n = matrix.count
    var dist = Array(repeating: Double.infinity, count: n)
    var pred = Array(repeating: -1, count: n)
    
    print("Detecting Arbitrage Cycle...")

    dist[0] = 0

    for _ in 0..<n - 1 {
        for u in 0..<n {
            for v in 0..<n {
                if dist[u] + matrix[u][v] < dist[v] {
                    dist[v] = dist[u] + matrix[u][v]
                    pred[v] = u
                }
            }
        }
    }

    // Check for negative-weight cycles
    for u in 0..<n {
        for v in 0..<n {
            if dist[u] + matrix[u][v] < dist[v] {
                // Negative-weight cycle found, backtrack to find the cycle
                var cycle: [Int] = [v]
                var current = pred[v]
                while current != v {
                    cycle.append(current)
                    current = pred[current]
                }
                cycle.reverse()
                cycle.append(v)

                return (true, cycle)
            }
        }
    }

    return (false, [])
}

internal func generateDate() -> String {
    let currentDate = Date()
    let randomTimeInterval = TimeInterval(arc4random_uniform(UInt32(5 * 365 * 24 * 60 * 60)))
    
    if let randomDate = Calendar.current.date(byAdding: .second, value: -Int(randomTimeInterval), to: currentDate) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: randomDate)
        
        return dateString
    } else {
        return "Error generating date"
    }
}
