//
//  StudentModel.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 05/06/24.
//

import Foundation

class ProductModel
{
   
    var id: Int? = 0
    var modelType : TypeItem? = nil// ledger or item product
    var ledgerType : LedgerModel? = nil
    var pName: String = ""
    var qty: Int? = 0
    var amount: Double? = 0.0 //its total of all same item.
    var price: Double = 0.0
    var inStock: Int = 0
    var addedByCustomer: Int = 0
    var discountedAmount: Double? = 0.0
    var imageData: Data? = nil
    
    init(){
        
    }
    init(id: Int, pName: String, price: Double, inStock: Int, addedByCustomer: Int)
    {
        self.id = id
        self.pName = pName
        self.price  = price
        self.inStock = inStock
        self.addedByCustomer = addedByCustomer
    }
}

struct MainProductModel
{
    var id: Int
    var selectedProduct: ProductModel
}

enum TypeItem: String
{
    case ledger = "ledger"
    case prodItem = "prodItem"
}
