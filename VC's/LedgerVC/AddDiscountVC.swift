//
//  ChooseProductVC.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 04/07/24.
//

import UIKit

class AddDiscountVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfProdName: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var imgDownArrow: UIImageView!
    @IBOutlet weak var tableViewProducts: UITableView!
    @IBOutlet weak var btnAddEditDel: UIButton!
   
    var totalAmount : Double = 0.0
    var arrProducts = [LedgerModel](){
        didSet{
            print("didSet set of arrProducts just called.")
            tableViewProducts.reloadData()
        }
    }
    
    var filteredProducts = [LedgerModel]()
    {
        willSet{
            print("will set of filteredProducts just called.")
            tableViewProducts.reloadData()
        }
        didSet{
            print("didSet set of filteredProducts just called.")
            tableViewProducts.reloadData()
        }
    }
    
     
    var tappedIndex = 0
    
    var crossImg = UIImage(systemName: "xmark.circle.fill")
    var downArrowImg = UIImage(systemName: "arrow.down.circle.fill")
    var ledgerApplied: ((LedgerModel) ->())? = nil //will be set from previous vc..already displaying..
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("total amout getting: \(totalAmount)")
        tableViewProducts.isHidden = true
        
        imgDownArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleTable)))
        
        tableViewProducts.delegate = self
        tableViewProducts.dataSource = self
        tfProdName.delegate = self
      
        
        arrProducts.append(contentsOf: AppConstants.shared.loadLedger())//addAll()
        filteredProducts.append(contentsOf: arrProducts)
        
        
    }
    
  
    
    @IBAction func actionDoneAdding(_ sender: Any) {
        var appliedLedger = filteredProducts[tappedIndex]
        appliedLedger.amount = Double(tfAmount.text?.replacingOccurrences(of: "$", with: "") ?? "0.0") ?? 0.0
        print("tfAmout.text: \(tfAmount.text)")
        ledgerApplied?(appliedLedger)
        navigationController?.popViewController(animated: true)
    }
    
    
}


