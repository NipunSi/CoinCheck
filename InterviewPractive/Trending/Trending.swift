//
//  Trending.swift
//  InterviewPractive
//
//  Created by Nipun Singh on 6/1/21.
//

import Foundation

struct Trending: Codable {  //Create a struct for the top most item, likely an array
    let coins: [Coin]
}

struct Coin: Codable { //Make a new item of everything in the array
    let item: Item
}

struct Item: Codable { //Create a let variable for each item in the JSON. Make sure the specificy the type of data it is
    let id: String
    let name: String
    let symbol: String
    let large: String
    let priceBtc: Double
    
    enum CodingKeys: String, CodingKey { //If the name needs to be formatted differently, use CodingKeys like this
        case id, name, symbol, large
        case priceBtc = "price_btc"
    }
}
