//
//  CrossProductVC ++.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 07/07/24.
//

import UIKit

extension AddDiscountVC
{
    // MARK: - Searching.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfProdName {
            // Create the new text string with the proposed change
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if newText.isEmpty {
                // If the new text is empty, hide the table view and show all products
                hideTable()
                filteredProducts.removeAll()
                filteredProducts.append(contentsOf: arrProducts)
                imgDownArrow.image = downArrowImg
            } else {
                // If the new text is not empty, filter the products and show the table view
                showTable()
                filteredProducts.removeAll()
               // filteredProducts.append(contentsOf: arrProducts.filter { $0.pName.lowercased().contains(newText.lowercased()) })
                imgDownArrow.image = crossImg
            }
            
            // Reload the table view in both cases
            // tableViewProducts.reloadData()
        }
      
        return true
    }
    
    @objc func toggleTable()
    {
        if imgDownArrow.image == crossImg// cross img
        {
            hideTable()
            tfProdName.text = ""
            imgDownArrow.image = downArrowImg
            
            filteredProducts.removeAll()
            filteredProducts.append(contentsOf: arrProducts)
            //tableViewProducts.reloadData()
        }
        else
        {
            tableViewProducts.isHidden = !tableViewProducts.isHidden
        }
    }
    
    func hideTable()
    {
        tableViewProducts.isHidden = true
    }
    
    func showTable()
    {
        tableViewProducts.isHidden = false
    }
}

// MARK: - UITableViewDataSource +  UITableViewDelegate.
extension AddDiscountVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell
        cell?.configureLedger(model: filteredProducts[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tappedIndex = indexPath.row
        tfProdName.text = filteredProducts[indexPath.row].ledgerType
        imgDownArrow.image = crossImg
        hideTable()
        
        
        if filteredProducts[indexPath.row].ledgerType == "VAT"
        {
            tfAmount.text = totalAmount.description
        }
        else
        {
            tfAmount.text = "$0"
        }
       
       
      
        
        
    }
    
}

