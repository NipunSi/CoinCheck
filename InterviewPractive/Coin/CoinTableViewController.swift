//
//  CoinTableViewController.swift
//  InterviewPractive
//
//  Created by Nipun Singh on 6/3/21.
//

import UIKit

class CoinTableViewController: UITableViewController {
    
    let networking = Networking()
    
    var coinID: String?
    var displayedCoin: CoinElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)

        getData()
    }

    func getData() {
        networking.getCoinData(coinID: coinID ?? "bitcoin") { (coin) in
            self.displayedCoin = coin
            DispatchQueue.main.async {
                self.title = "\(coin.name)"
                
                let imageView = UIImageView(image: UIImage(named: "slowmo"))
                imageView.imageFromServerURL(urlString: coin.image.thumb, PlaceHolderImage: UIImage(systemName: "slowmo")!)
                imageView.maskCircle()
                let buttonItem = UIBarButtonItem(customView: imageView)
                
                self.navigationItem.rightBarButtonItem = buttonItem
                
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getData()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 9
        } else {
            return 10
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Market Stats"
        } else {
            return "Price Stats"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statCell", for: indexPath)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Symbol"
                cell.detailTextLabel?.text = displayedCoin?.symbol.uppercased()
            case 1:
                cell.textLabel?.text = "Current price"
                cell.detailTextLabel?.text = "$\(displayedCoin?.marketData.currentPrice["usd"] ?? 0.00)"
            case 2:
                cell.textLabel?.text = "Market Cap"
                cell.detailTextLabel?.text = "$\(Int(displayedCoin?.marketData.marketCap["usd"] ?? 0.00).formatNumber())"
            case 3:
                cell.textLabel?.text = "Market Cap Rank"
                cell.detailTextLabel?.text = "#\(displayedCoin?.marketCapRank ?? 0)"
            case 4:
                cell.textLabel?.text = "Volume (24h)"
                cell.detailTextLabel?.text = "$\(Int(displayedCoin?.marketData.totalVolume["usd"] ?? 0.00).formatNumber())"
            case 5:
                cell.textLabel?.text = "Circulating Supply"
                cell.detailTextLabel?.text = "\(Int(displayedCoin?.marketData.circulatingSupply ?? 0.00).formatNumber())"
            case 6:
                cell.textLabel?.text = "Public Sentiment"
                cell.detailTextLabel?.text = "\(displayedCoin?.sentimentVotesUpPercentage ?? 0)% Positive"
            case 7:
                cell.textLabel?.text = "Official Website"
                cell.detailTextLabel?.text = "\(displayedCoin?.links.homepage.first ?? "None")"
            case 8:
                cell.textLabel?.text = "Genesis Date"
                cell.detailTextLabel?.text = "\(displayedCoin?.genesisDate ?? "Unknown")"
            default:
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
            }
        } else {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "All Time High"
                cell.detailTextLabel?.text = "$\(displayedCoin?.marketData.ath["usd"] ?? 0.00)"
            case 1:
                if let change = displayedCoin?.marketData.athChangePercentage["usd"] {
                    cell.textLabel?.text = "Change From ATH"
                    cell.detailTextLabel?.text = "\(String(format: "%.2f", change))%"
                }
            case 2:
                cell.textLabel?.text = "Daily High"
                cell.detailTextLabel?.text = "$\(displayedCoin?.marketData.high24H["usd"] ?? 0.00)"
            case 3:
                cell.textLabel?.text = "Daily Low"
                cell.detailTextLabel?.text = "$\(displayedCoin?.marketData.low24H["usd"] ?? 0.00)"
            case 4:
                if let myDouble = displayedCoin?.marketData.marketCapChangePercentage24H {
                    let mktCapPercentChange = String(format: "%.2f", myDouble)
                    cell.textLabel?.text = "Mkt. Cap Change (24h)"
                    cell.detailTextLabel?.text = "$\(Int(displayedCoin?.marketData.marketCapChange24H ?? 0.00).formatNumber()) (\(mktCapPercentChange)%)"
                    
                    if myDouble < 0 {
                        cell.detailTextLabel?.textColor = .systemRed
                    } else {
                        cell.detailTextLabel?.textColor = .systemGreen
                    }
                    
                }
            case 5:
                if let change = displayedCoin?.marketData.priceChangePercentage1HInCurrency["usd"] {
                    cell.textLabel?.text = "Price (1h)"
                    cell.detailTextLabel?.text = "\(String(format: "%.2f", change))%"
                    
                    if change < 0 {
                        cell.detailTextLabel?.textColor = .systemRed
                    } else {
                        cell.detailTextLabel?.textColor = .systemGreen
                    }
                }
            case 6:
                if let change = displayedCoin?.marketData.priceChangePercentage24H {
                    cell.textLabel?.text = "Price (24h)"
                    cell.detailTextLabel?.text = "\(String(format: "%.2f", change))%"
                    
                    if change < 0 {
                        cell.detailTextLabel?.textColor = .systemRed
                    } else {
                        cell.detailTextLabel?.textColor = .systemGreen
                    }
                }
            case 7:
                if let change = displayedCoin?.marketData.priceChangePercentage7D {
                    cell.textLabel?.text = "Price (7d)"
                    cell.detailTextLabel?.text = "\(String(format: "%.2f", change))%"
                    
                    if change < 0 {
                        cell.detailTextLabel?.textColor = .systemRed
                    } else {
                        cell.detailTextLabel?.textColor = .systemGreen
                    }
                }
            case 8:
                if let change = displayedCoin?.marketData.priceChangePercentage30D {
                    cell.textLabel?.text = "Price (30d)"
                    cell.detailTextLabel?.text = "\(String(format: "%.2f", change))%"
                    
                    if change < 0 {
                        cell.detailTextLabel?.textColor = .systemRed
                    } else {
                        cell.detailTextLabel?.textColor = .systemGreen
                    }
                }
            case 9:
                if let change = displayedCoin?.marketData.priceChangePercentage1Y {
                    cell.textLabel?.text = "Price (365d)"
                    cell.detailTextLabel?.text = "\(String(format: "%.2f", change))%"
                    
                    if change < 0 {
                        cell.detailTextLabel?.textColor = .systemRed
                    } else {
                        cell.detailTextLabel?.textColor = .systemGreen
                    }
                }
            default:
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
            }
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
