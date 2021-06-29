//
//  Market.swift
//  InterviewPractive
//
//  Created by Nipun Singh on 6/2/21.
//

import Foundation

struct Market: Codable {
    let id: String
    let name: String
    let image: String
    let symbol: String
    let currentPrice: Double
    let marketCap: Double
    let priceChange24h: Double
    let priceChangePercentage24h: Double
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, symbol
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
    }
}
