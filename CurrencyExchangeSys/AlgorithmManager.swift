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

internal func getArbitageCycle(matrix: [[Double]]) -> (hasArbitageChance: Bool, path: [Int], resultRatio: Double){
    let vertexCount = matrix.count
    var hasArbitrageChance = false
    var vertexPath : [Int] = []
    var resultRatio : Double = 0.0
    
    // Perform Bellman-Ford algorithm to find maximum rate path for bidirectional paths
    for source in 0..<vertexCount {
        var distance = Array(repeating: -Double.greatestFiniteMagnitude, count: vertexCount)
        var predecessor = Array(repeating: -1, count: vertexCount)
        
        distance[source] = 0
        
        // Loop through vertices
        for _ in 0..<vertexCount - 1 {
            // Loop through edges
            for u in 0..<vertexCount {
                for v in 0..<vertexCount {
                    let rate = matrix[u][v] // Rate from u to v
                    if rate != 0 && distance[u] + log(rate) > distance[v] {
                        distance[v] = distance[u] + log(rate)
                        predecessor[v] = u
                    }
                }
            }
        }
        
        // Check for positive cycle
        for u in 0..<vertexCount {
            let rate = matrix[u][source] // Rate from u to source
            if rate != 0 && distance[u] + log(rate) > distance[source] {
                // Positive cycle detected
                var current = source
                var cycle: [Int] = []
                var visited = Array(repeating: false, count: vertexCount) // To track visited nodes
                
                for _ in 0..<vertexCount {
                    current = predecessor[current]
                }
                
                let start = current
                cycle.append(start)
                visited[start] = true // Mark start node as visited
                current = predecessor[current]
                
                while current != start {
                    cycle.append(current)
                    visited[current] = true // Mark current node as visited
                    current = predecessor[current]
                }
                
                let rateProduct = exp(distance[source])
                if rateProduct > 1 {
                    hasArbitrageChance = true
                    vertexPath = cycle.reversed() // Reversed path to show from source to destination
                    
                    // Construct the output path array
                    var outputPath: [Int] = []
                    for i in 0..<vertexCount {
                        if visited[i] {
                            outputPath.append(i)
                        }
                    }
                    
                    resultRatio = rateProduct
                    return (hasArbitrageChance, outputPath, resultRatio)
                }
            }
        }
    }

    return (hasArbitrageChance, vertexPath, resultRatio)
}

internal func displayArbitageCycle(currencyArray: [String], vertexVisited: [Int]) -> String{
    var resultMessage = ""
    
    for indexInVertex in 0..<vertexVisited.count - 1 {
        var lineInfo = ""
        
        for _ in 0..<currencyArray.count{
            lineInfo = "\(indexInVertex + 1). Change from \(currencyArray[vertexVisited[indexInVertex]]) to \(currencyArray[vertexVisited[indexInVertex + 1]])"
        }
    
        resultMessage.append("\(lineInfo)\n")
    }
    
    return resultMessage
}
