//
//  ProductMainCell.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 07/07/24.
//

import UIKit

class ProductMainCell: UITableViewCell {

    @IBOutlet weak var stackViewLast: UIStackView!
  //  @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var btnEdit: UIButton!
    //@IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var btnEditTapped: (()->())? = nil
    var btnDeleteTapped: (()->())? = nil
    
    override func awakeFromNib() {
        /*if stackViewLast.isHidden
        {
            UIView.animate(withDuration: 0.3) {
                self.constraintHeight.constant = 130
                self.layoutIfNeeded()
            }
            
            
        }
        else
        {
            UIView.animate(withDuration: 0.3) {
                self.constraintHeight.constant = 200
                self.layoutIfNeeded()
            }
        }
         */
        
    }
    @IBAction func actionDelete(_ sender: Any) {
        btnDeleteTapped?()
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        btnEditTapped?()
    }
}
