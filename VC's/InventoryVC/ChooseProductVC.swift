//
//  ChooseProductVC.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 04/07/24.
//

import UIKit

class ChooseProductVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imgDownArrow: UIImageView!
    @IBOutlet weak var tableViewProducts: UITableView!
    @IBOutlet weak var tfProdName: UITextField!
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfUnit: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var btnAddEditDel: UIButton!
    
    var arrProducts = [Item](){
        didSet{
            print("didSet set of arrProducts just called.")
            filteredProducts.append(contentsOf: arrProducts)
            tableViewProducts.reloadData()
        }
    }
    
    var filteredProducts = [Item]()
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
    
    var editableProductModel : ProductModel? = nil
    
    var tappedIndex = 0
    
    var crossImg = UIImage(systemName: "xmark.circle.fill")
    var downArrowImg = UIImage(systemName: "arrow.down.circle.fill")
    var newProductAdded: ((ProductModel) ->())? = nil //will be set from previous vc..already displaying..
    var sameProductEdited: ((ProductModel) ->())? = nil //will be set from previous vc..already displaying.
    
    var prefs = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIfEditing()
        tableViewProducts.isHidden = true
        tableViewProducts.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        imgDownArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleTable)))
        
        tableViewProducts.delegate = self
        tableViewProducts.dataSource = self
        tfProdName.delegate = self
        tfQuantity.delegate = self
        loadFromServer()
        
    }
    
    func loadIfEditing()
    {
        if let modelToEdit = editableProductModel
        {
            print("to edit and fill the contents.")
            tfProdName.text = modelToEdit.pName.description
            // tfUnit = modelToEdit.
            tfQuantity.text = modelToEdit.qty?.description
            tfPrice.text = modelToEdit.price.description
            tfAmount.text = modelToEdit.amount?.description
            
            btnAddEditDel.setTitle("Edit", for: .normal)
        }
        else
        {
            print("you need to select")
        }
    }
    
    func loadFromServer() {
        DispatchQueue.main.async{[self] in
            arrProducts.removeAll()
            showProgress()
        }
        // Call the method to fetch all items
        NetworkManagerService.shared.fetchAllItems { result in
            DispatchQueue.main.async { [self] in
                
                
                switch result {
                case .success(let model):
                    //self.lblError.isHidden = true
                    if let items = model.data {
                        print("Options received: \(items)")
                        
                        DispatchQueue.main.async{self.arrProducts = items}
                        
                    } else {
                        print("No data received.")
                        // Handle the case where there is no data
                    }
                    
                case .failure(let error):
                    print("Failed to fetch data: \(error)")
                    // self.showToast(error.localizedDescription, msg: "issue", position: .top)
                    //self.lblError.text = error.localizedDescription
                   // self.lblError.isHidden = false
                    // Handle the error, show an alert, etc.
                }
                hideProgress()
            }
        }
    }
    
    
    @IBAction func actionDoneAdding(_ sender: Any) {
        if tappedIndex >= 0 {
            
                if let modelToEdit = editableProductModel{
                    whileEditingInventory()}
                else
                {
                    whileAddingNewInventory()
                }
        }
        else
        {
            showToast("Select from list first", msg: ".", position: .top)
        }
    }
    
    func whileAddingNewInventory()
    {
        var selectedProdModel = filteredProducts[tappedIndex]
        
        var modelPrev = ProductModel(id: Int(/selectedProdModel.id) ?? 0,
                                     pName: selectedProdModel.name ?? "",
                                     price: Double(selectedProdModel.price ?? "0.0") ?? 0.0,
                                     inStock: 0, addedByCustomer: 1)
        
        
        modelPrev.qty = Int(tfQuantity.text ?? "1") ?? 1
        
        
        if let amountText = tfAmount.text {
            let cleanedAmount = amountText.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
            modelPrev.amount = Double(cleanedAmount) ?? 0.0
        }
        newProductAdded!(modelPrev)
        navigationController?.popViewController(animated: true)
    }
    
    func whileEditingInventory()
    {
        if let modelToEdit = editableProductModel
                   {
                       var selectedProdModel = modelToEdit
                       selectedProdModel.qty = Int(tfQuantity.text ?? "1") ?? 1
                       
                       
                       if let amountText = tfAmount.text {
                           let cleanedAmount = amountText.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
                           selectedProdModel.amount = Double(cleanedAmount) ?? 0.0
                       }
                       
                      
            sameProductEdited!(selectedProdModel)
                   }
        navigationController?.popViewController(animated: true)
    }
}


