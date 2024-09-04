//
//  ProductCell.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 04/07/24.
//

import UIKit
import SDWebImage

class ProductCell: UITableViewCell {

    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var imgProd: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    
    // Create an activity indicator
    //private var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialize the activity indicator and add it to the image view
       /* activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .red
        activityIndicator.hidesWhenStopped = true
        imgProd.addSubview(activityIndicator)
        
        // Center the activity indicator within the image view
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: imgProd.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: imgProd.centerYAnchor).isActive = true
        */
    }

    func configure(model: Item) {
        lblProdName.text = model.name
        lblPrice.text = "$" + String(model.price ?? "")
        
        // Start animating the activity indicator before the image loads
       // activityIndicator.startAnimating()
        
        imgProd.sd_setImage(with: URL(string: model.image ?? ""), placeholderImage: UIImage(named: "calendar")) { [weak self] (image, error, cacheType, url) in
            // Stop the activity indicator once the image is loaded
           // self?.activityIndicator.stopAnimating()
        }
    }
    
    func configureLedger(model: LedgerModel) {
        lblProdName.text = model.ledgerType
        lblPrice.text = "$" + String(model.amount)
        
        
    }
}

