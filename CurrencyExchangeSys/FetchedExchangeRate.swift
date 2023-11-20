//
//  FetchedExchangeRate.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/18.
//
import Foundation

struct FetchedLatestExchangeRate: Codable {
    var data: [String: Double]
}

struct FetchedHistoricalExchangeRate : Codable {
    let data: [String: [String: Double]]
}

