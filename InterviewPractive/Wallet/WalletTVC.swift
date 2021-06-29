//
//  WalletTVC.swift
//  InterviewPractive
//
//  Created by Nipun Singh on 6/25/21.
//

import UIKit

class WalletTVC: UITableViewController {

    let api = Networking()
    var formatter = NumberFormatter()
    var walletCoins = [WalletCoin]()
    var selectedCoinID: String?
    
    let coins = ["bitcoin": 0.821421, "ethereum": 29.1321, "dogecoin": 211644.1128, "cardano": 7912.977]
    var totalValue = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: nil)        
      
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        getPrices {
            print("Finished getting \(self.walletCoins.count ) prices. Reloading table")
            DispatchQueue.main.async {
                
                //Sort coins by value
                self.tableView.reloadData()
                               
                self.navigationItem.title = self.formatter.string(from: NSNumber(value: self.totalValue))
            }
        }
    }
    
    func getPrices(completion: @escaping () -> Void) {
        var i = 0
        for coin in coins {
            api.getCoinData(coinID: coin.key) { coinData in
                i += 1
                
                let value =  (coinData.marketData.currentPrice["usd"] ?? 0) * (coin.value)
            
                let newCoin = WalletCoin(ticker: coinData.symbol, name: coinData.name, amount: coin.value, value: value, imageURL: coinData.image.large, id: coinData.id)
                
                self.walletCoins.append(newCoin)
                print("walletCoins count: \(self.walletCoins.count)")
                self.totalValue += value
                
                print("Adding coin: \(newCoin.name) worth $\(newCoin.value)")
                
                if i == self.coins.count {
                    completion()
                }
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getPrices {
            print("Finished getting \(self.walletCoins.count ) prices. Reloading table")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                               
                self.navigationItem.title = self.formatter.string(from: NSNumber(value: self.totalValue))
            }
        }
        refreshControl?.endRefreshing()
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletCoins.count 
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as! WalletCell

        cell.walletCoin = walletCoins[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCoinID = walletCoins[indexPath.row].id
        performSegue(withIdentifier: "walletToCoinSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "walletToCoinSegue" {
            if let vc = segue.destination as? CoinTableViewController {
                vc.coinID = selectedCoinID
            }
        }
    }
    
    
}
