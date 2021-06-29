//
//  WalletCell.swift
//  InterviewPractive
//
//  Created by Nipun Singh on 6/25/21.
//

import UIKit

class WalletCell: UITableViewCell {

    @IBOutlet weak var coinImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var walletCoin: WalletCoin? {
        didSet {
            guard let coin = walletCoin else { return }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            
            print("Setting up cell for \(coin.name)")
            nameLabel.text = coin.name
            amountLabel.text = "\(coin.amount) \(coin.ticker.uppercased())"
            valueLabel.text = formatter.string(from: NSNumber(value: coin.value))
            
            coinImageVIew.maskCircle()
            coinImageVIew.imageFromServerURL(urlString: coin.imageURL, PlaceHolderImage: UIImage(systemName: "slowmo")!)
        }
    }
}
