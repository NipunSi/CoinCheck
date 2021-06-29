//
//  Networking.swift
//  InterviewPractive
//
//  Created by Nipun Singh on 6/3/21.
//

import Foundation

class Networking {
    
    func getMarketCaps(completion: @escaping ([Market]) -> Void) {
            print("Getting Coin Data")
            let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false"
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { (data, res, err) in
                   
                    if let err = err {
                        print("Error getting coin data: \(err)")
                        return
                    }
                    
                    if let data = data {
                        do {
                            let marketData = try JSONDecoder().decode([Market].self, from: data)
                            
                            completion(marketData)
                            
                            //print(marketData)
                        } catch  {
                            print("Error decoding market data: \(error)")
                        }
                    } else {
                        print("Error getting data")
                    }
                    
                }.resume()
            }
            
        }
    
    func getCoinData(coinID: String, completion: @escaping (CoinElement) -> Void) {
        
        print("Getting Coin Data")
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coinID)?localization=false&tickers=false"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, res, err) in
               
                if let err = err {
                    print("Error getting coin data: \(err)")
                    return
                }
                
                if let data = data {
                    do {
                        let coinData = try JSONDecoder().decode(CoinElement.self, from: data)
                        
                        completion(coinData)
                        
                        //print(coinData)
                    } catch  {
                        print("Error decoding coin data: \(error)")
                    }
                } else {
                    print("Error getting data")
                }
                
            }.resume()
        }
        
    }
}
