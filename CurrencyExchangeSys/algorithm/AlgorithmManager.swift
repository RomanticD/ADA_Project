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

internal func displayArbitageCycle(currencyArray: [String], vertexVisited: [Int]) -> String{
    var resultMessage = ""
    
    if vertexVisited.isEmpty{
        return ""
    }
    
    for indexInVertex in 0..<vertexVisited.count - 1 {
        var lineInfo = ""
        
        for _ in 0..<currencyArray.count{
            let indexA = vertexVisited[indexInVertex]
            let indexB = vertexVisited[indexInVertex + 1]
            
            if ((indexA > currencyArray.count - 1) || (indexB > currencyArray.count - 1)) {
                print("array index out of bounds!")
                return ""
            }
            
            lineInfo = "\(indexInVertex + 1). Change from \(currencyArray[indexA]) to \(currencyArray[indexB])"
        }
    
        resultMessage.append("\(lineInfo)\n")
    }
    
    return resultMessage
}

enum DisplayMode {
    case found, notFound, errorRange
}

internal func getProfitInfo(ratioAfterExchange : Double) -> (displayMode: DisplayMode, message: String) {
    guard ratioAfterExchange > 1 else {
        return (.notFound, "You have no chance of profit😭")
    }

    guard ratioAfterExchange > 1.00001 else {
        return (.errorRange, "You may have a chance for profit, but it is quite limited😐")
    }
    
    var profit = Int((round(ratioAfterExchange * 100000) / 100000 - 1) * 100000)
    var index = 0
    while profit % 10 == 0 {
        profit = profit / 10
        index = index + 1
    }
    profit = profit + 1
    while profit % 10 == 0 {
        profit = profit / 10
        index = index + 1
    }
        
    return (.found, "You can earn \(profit)💰 of profit for every \(100000/pow(10, index))💰 of currency exchanged！ ")
}

/**
 Performs Bellman-Ford algorithm to find the maximum rate path for bidirectional paths and determines if there's an arbitrage chance.

 - Parameters:
    - matrix: A two-dimensional array representing the currency conversion rates.

 - Returns: A tuple containing information about the arbitrage chance:
    - `hasArbitrageChance`: A boolean indicating if there's an arbitrage chance.
    - `vertexPath`: An array representing the vertex path for the arbitrage.
    - `resultRateSet`: An array of rates that form the arbitrage.
    - `result`: The maximum rate from the arbitrage.
*/
internal func findArbitrageChanceInfo(matrix: [[Double]]) -> (hasArbitrageChance: Bool, vertexPath: [Int], resultRateSet: [Double], result: Double){
    let vertexCount = matrix.count
    var hasArbitrageChance = false
    var path : [Int] = []
    var resultRateSet : [Double] = []

    // I use Bellman-Ford algorithm partly to find the best path
    // Distance means the best path value of the vertex, not the value from current to source
    // Predecessor means the previous node, it's the crucial to give the graph of path
    var distance = Array(repeating: -Double.greatestFiniteMagnitude, count: vertexCount)
    var predecessor = Array(repeating: -1, count: vertexCount)
    distance[0] = 0
    
    // The part of Bellman-Ford algorithm, but does not simply utilize it
    for _ in 0..<vertexCount-1 {
        for u in 0..<vertexCount {
            for v in 0..<vertexCount {
                let rate = matrix[u][v]
                // Every time it become the new predecessor, every distance of node will update
                // And if the value of path < former, it will not update
                if rate != 0 && distance[u] + log(rate) > distance[v] {
                    let former: Int = predecessor[v]
                    predecessor[v] = u
                    if calculateDis(source: v).distance < distance[v]{
                        predecessor[v] = former
                        break
                    }
                    for i in 0..<distance.count{
                        distance[i] = calculateDis(source: i).distance
                    }
                    print(u,":", exp(distance[u]), "->", v, ":", exp(distance[v]))
                }
            }
        }
    }
    
    // After we got the predecessor and distance of every vertex, we can check if it has the circle we want
    // Circle Dis and Index record the distance and index of the vertex that has circle
    // Max Dis and Index means we get the max distance and index of vertex that has circle
    var maxDis: Double = 0
    var maxIndex: Int = -1
    var circleDis: [Double] = []
    var circleIndex: [Int] = []
    // If we just have two or more same distance of vertex, it means there is circle
    for i in 0..<vertexCount{
        for j in i+1..<vertexCount{
            if distance[i] == distance[j] && !circleDis.contains(distance[j]){
                circleDis.append(distance[i])
                circleIndex.append(i)
            }
        }
    }
    // Get the max value of vertex that has circle
    for i in 0..<circleDis.count{
        if maxDis < circleDis[i]{
            maxDis = circleDis[i]
            maxIndex = circleIndex[i]
        }
    }
    
    // If maxIndex is -1, that means there isn't circle
    if maxIndex != -1 {
        path = calculateDis(source: maxIndex).path
        resultRateSet = calculateDis(source: maxIndex).resultSet
    }
    
    // Test the correctness of code
    for i in 0..<distance.count{
        print(exp(distance[i]))
    }
    print(predecessor)
    
    if exp(maxDis) > 1 {
        hasArbitrageChance = true
        
        print("result rate set: \(resultRateSet)")
        print("result path: \(path.reversed())")
        
        return (hasArbitrageChance, path.reversed(), resultRateSet, exp(maxDis))
    }
    
    // Calculate the best value of path - distance
    func calculateDis(source: Int) -> (distance: Double, path: [Int], resultSet: [Double]){
        var current = source
        var currentPath: [Int] = []
        var resultSet: [Double] = []
        
        // Find the current path of the source node
        // iterate the nodes until it is void or become circle
        while predecessor[current] != -1 && !currentPath.contains(predecessor[current]) {
            currentPath.append(current)
            current = predecessor[current]
        }
        currentPath.append(current)
        
        // Add the every rate of edge
        var distance: Double = 0
        for i in 0..<currentPath.count{
            if predecessor[currentPath[i]] == -1 {
                break
            }
            if i == currentPath.count - 1 {
                distance += log(matrix[predecessor[current]][currentPath[i]])
                resultSet.append(matrix[predecessor[current]][currentPath[i]])
            } else {
                distance += log(matrix[currentPath[i+1]][currentPath[i]])
                resultSet.append(matrix[currentPath[i+1]][currentPath[i]])
            }
        }
        
        return (distance, currentPath, resultSet)
    }

    return (hasArbitrageChance, path.reversed(), resultRateSet, exp(maxDis))
}
