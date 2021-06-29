//
//  ViewController.swift
//  InterviewPractive
//
//  Created by Nipun Singh on 6/1/21.
//

import UIKit

class CoinCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
}

class ViewController: UITableViewController {
    
    var topCryptos = [Item]()
    var selectedCoinID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Trending"
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        getData()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getData()
        refreshControl?.endRefreshing()
    }
    
    //MARK: - Fetch Data
    
    func getData() {
        let urlString = "https://api.coingecko.com/api/v3/search/trending" //1. Set the API url
        if let url = URL(string: urlString) { //2. Check to make sure its not nil
            URLSession.shared.dataTask(with: url) { (data, res, err) in //3. Make the actual URLSession
                
                if let err = err { //4. Check for the error, return if found
                    print("Error with fetching the data: \(err)")
                    return
                }
                
                if let data = data { //5. Access the data safely by checking if it exists
                    
                    do { //Try to decode the data to a codable class within a do-catch statement
                        let fetchedData = try JSONDecoder().decode(Trending.self, from: data) // Use JSONDecoder to decode the data and assign it to a variable
                        print("Got Data for \(fetchedData.coins.count) coins.")
                        
                        for coin in fetchedData.coins {
                            self.topCryptos.append(coin.item)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } catch  {
                        print("Error decoding the data: \(error)")
                    }
                    
                }
                
            }.resume() //Run the URLSession by adding .resume() to the end of the bracked
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trendingToCoinSegue" {
            if let vc = segue.destination as? CoinTableViewController {
                vc.coinID = selectedCoinID
            }
        }
    }
    
    
    //MARK: - TableView Setup
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topCryptos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath) as! CoinCell
        
        let coin = topCryptos[indexPath.row]
        cell.thumbnail.maskCircle()
        cell.thumbnail?.imageFromServerURL(urlString: coin.large, PlaceHolderImage: UIImage(systemName: "slowmo")!)
        cell.nameLabel.text = coin.name
        cell.symbolLabel.text = coin.symbol
        cell.priceLabel.text = "$\(String(format: "%.4f", coin.priceBtc * 36190))"//Price of BTC
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCoinID = topCryptos[indexPath.row].id
        performSegue(withIdentifier: "trendingToCoinSegue", sender: self)
    }
    
}

extension UIImageView {

 public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {

        if self.image == nil{
              self.image = PlaceHolderImage
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }}

