//
//  StatsCollectionViewController.swift
//  InterviewPractive
//
//  Created by Nipun Singh on 6/2/21.
//

import UIKit

class CoinInfoCell: UICollectionViewCell {
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var primaryLabel: UILabel!
    @IBOutlet var secondaryLabel: UILabel!
}

class StatsCollectionViewController: UICollectionViewController {
    let refreshControl = UIRefreshControl()
    let networking = Networking()
    var coins = [Market]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)

        
        networking.getMarketCaps { (marketData) in
            self.coins = marketData
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        networking.getMarketCaps { (marketData) in
            self.coins = marketData
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coins.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coinInfoCell", for: indexPath) as! CoinInfoCell
        
        let coin = coins[indexPath.row]
        
        cell.coinImageView.maskCircle()
        cell.coinImageView?.imageFromServerURL(urlString: coin.image, PlaceHolderImage: UIImage(systemName: "slowmo")!)
        cell.primaryLabel.text = coin.name
        cell.secondaryLabel.text = "$\(Int(coin.marketCap).formatNumber())"
    
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        cell.layer.masksToBounds = false
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension UIImageView {
  public func maskCircle() {
    self.contentMode = UIView.ContentMode.scaleAspectFill
    self.layer.cornerRadius = self.frame.height / 2
    self.layer.masksToBounds = false
    self.clipsToBounds = true

  }
}
