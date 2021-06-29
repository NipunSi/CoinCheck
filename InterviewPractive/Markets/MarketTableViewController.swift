//
//  MarketTableViewController.swift
//  InterviewPractive
//
//  Created by Nipun Singh on 6/2/21.
//

import UIKit

class CoinDataCell: UITableViewCell {
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
}

class MarketTableViewController: UITableViewController {

    var coins = [Market]()
    
    var selectedCoinID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        getCoins()
    }
    
    func getCoins() {
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
                        
                        for coin in marketData {
                            self.coins.append(coin)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
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
    
    @objc func refresh(_ sender: AnyObject) {
        getCoins()
        refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "marketToCoinSegue" {
            if let vc = segue.destination as? CoinTableViewController {
                vc.coinID = selectedCoinID
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinDataCell", for: indexPath) as! CoinDataCell

        let coin = coins[indexPath.row]
        
        cell.coinImage.maskCircle()
        cell.coinImage?.imageFromServerURL(urlString: coin.image, PlaceHolderImage: UIImage(systemName: "slowmo")!)
        cell.nameLabel.text = coin.name
        cell.secondaryLabel.text = "\(coin.symbol.uppercased())"// - Mkt Cap: $\(Int(coin.marketCap).formatNumber())"
        cell.priceLabel.text = "$\(String(format: "%.2f", coin.currentPrice))"
        cell.changeLabel.text = "\(String(format: "%.2f", coin.priceChangePercentage24h))%"
        if coin.priceChangePercentage24h < 0 {
            cell.changeLabel.textColor = .systemRed
        } else {
            cell.changeLabel.textColor = .systemGreen
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCoinID = coins[indexPath.row].id
        performSegue(withIdentifier: "marketToCoinSegue", sender: self)
    }
    

}

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}

extension Int {
    func formatNumber() -> String {
        let n = Int(self)
        let num = abs(Double(n))
        let sign = (n < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)M"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)K"

        case 0...:
            return "\(n)"

        default:
            return "\(sign)\(n)"
        }
    }
}
