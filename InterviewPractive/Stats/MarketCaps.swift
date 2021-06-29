//
//  MarketCaps.swift
//  InterviewPractive
//
//  Created by Nipun Singh on 6/3/21.
//

import Foundation

struct MarketCaps: Codable {
    let data: Data
}

struct Data: Codable {
    let totalMarketCap: [String: Double]
}

