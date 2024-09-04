//
//  ChooseProductVC.swift
//  Sanjay Prject
//
//  Created by Amanpreet Singh on 04/07/24.
//

import UIKit

class ListProductsFromServerVC: BaseViewController, UITextFieldDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableViewProducts: UITableView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let refreshControl = UIRefreshControl()
    
    var arrProducts = [Item](){
        didSet{
            print("didSet set of arrProducts just called.")
            filteredProducts.removeAll()
            filteredProducts.append(contentsOf: arrProducts)
            activityIndicator.stopAnimating()
            
            tableViewProducts.reloadData()
            if !arrProducts.isEmpty {
                
                let lastIndexPath = IndexPath(row: arrProducts.count - 1, section: 0)
                tableViewProducts.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            }
            
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
    
    //var editableProductModel : ProductModel? = nil
    var tappedIndex = 0
    var prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewProducts.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        refreshControl.addTarget(self, action: #selector(hitApiLoadProducts), for: .valueChanged)
        tableViewProducts.refreshControl = refreshControl
        tableViewProducts.delegate = self
        tableViewProducts.dataSource = self
        searchBar.delegate = self
        hitApiLoadProducts()
    }
    
     @objc func hitApiLoadProducts() {
        DispatchQueue.main.async{[self] in
            activityIndicator.startAnimating()
            arrProducts.removeAll()
            showProgress()
        }
        // Call the method to fetch all items
        NetworkManagerService.shared.fetchAllItems { result in
            DispatchQueue.main.async { [self] in
                refreshControl.endRefreshing()
                activityIndicator.stopAnimating()
                
                switch result {
                case .success(let model):
                    self.lblError.isHidden = true
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
                    self.lblError.text = error.localizedDescription
                    self.lblError.isHidden = false
                    // Handle the error, show an alert, etc.
                }
                hideProgress()
            }
        }
    }

    @IBAction func actionAddNewItem(_ sender: Any) {
        performSegue(withIdentifier: "toAddNewItem", sender: nil)
    }
    
    // This method gets called whenever the text in the search bar changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is now: \(searchText)")
        
        // If searchText is empty, display all products
        if searchText.isEmpty {
            filteredProducts = arrProducts
        } else {
            // Filter products based on searchText
            filteredProducts = arrProducts.filter { product in
                if let nameString = product.name
                {
                    return nameString.lowercased().contains(searchText.lowercased())
                }
                return false
            }
        }
        
        // Reload the table view with filtered data
        tableViewProducts.reloadData()
    }
    
    // This method gets called when the search button (Return key) is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide the keyboard
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddNewItem"
        {
            if let vc = segue.destination as? AddNewProductNetworkVC
            {
                vc.isDataSaved = {
                    self.hitApiLoadProducts()
                }
            }
        }
        else if segue.identifier == "toUpdateProduct"
        {
            if let vc = segue.destination as? UpdateProductNetworkVC{
                vc.editableProductModel = arrProducts[tappedIndex]
               
                // Step 1 //  assign Another class's vc
                vc.itemUpdated =  {
                    self.hitApiLoadProducts()
                }
                
                
            }
        }
    }
}


extension ListProductsFromServerVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell
        cell?.configure(model: filteredProducts[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedIndex = indexPath.row
        performSegue(withIdentifier: "toUpdateProduct", sender: nil)
    }
    
}
