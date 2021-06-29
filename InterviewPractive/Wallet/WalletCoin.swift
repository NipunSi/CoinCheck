//
//  WalletCoin.swift
//  InterviewPractive
//
//  Created by Nipun Singh on 6/25/21.
//

import Foundation

struct WalletCoin: Codable {
    let ticker: String
    let name: String
    let amount: Double
    var value: Double
    let imageURL: String
    let id: String
}
