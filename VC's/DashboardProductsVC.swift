//
//  DashboardProductsVC.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 07/07/24.
//


import UIKit

class DashboardProductsVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalQuantity: UILabel!
    @IBOutlet weak var lblVat: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var btnDateSelecting: UIButton!
    
    @IBOutlet weak var viewOptions: UIView!
    
    @IBOutlet weak var lblAddInventory: UILabel!
    @IBOutlet weak var lblAddLedger: UILabel!
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    private var appConstants = AppConstants.shared
    private var tappedIndex = 0
    var isBottomViewExpanded = false
    
    var arrSelectedProducts = [MainProductModel]()
    {
        didSet{
            var totalQuan = 0
            var totalAmount = 0.0
            for i in arrSelectedProducts
            {
                totalQuan += i.selectedProduct.qty ?? 0
                totalAmount += i.selectedProduct.amount ?? 0.0
            }
            lblTotalAmount.text = totalAmount.description
            lblTotalQuantity.text = totalQuan.description
            tableView.reloadData()
        }
    }
    
    @objc func actionToggleMenu(_ sender: Any) {
         /*  isBottomViewExpanded.toggle()
           
           // Adjust the height constraint and animate the change
           UIView.animate(withDuration: 0.5, animations: {
               if self.isBottomViewExpanded {
                   self.menuHeightConstraint.constant = 80 // Expand to 300 points
                   //self.toggleButton.setTitle("▼", for: .normal) // Change arrow direction
               } else {
                   self.menuHeightConstraint.constant = 0 // Collapse to 0 points
                   //self.toggleButton.setTitle("▲", for: .normal) // Change arrow direction
               }
               self.view.layoutIfNeeded() // Animate the layout changes
           })
          */
        showActionSheet()
       }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProductMainCell", bundle: nil), forCellReuseIdentifier: "ProductMainCell")
        tableView.register(UINib(nibName: "HeaderViewCell", bundle: nil), forCellReuseIdentifier: "HeaderViewCell")
        tableView.sectionHeaderHeight = 80
        
       // tableView.estimatedRowHeight = 200 // Set an estimated row height
        tableView.rowHeight = UITableView.automaticDimension
        
        lblTotalQuantity.text = "--"
        lblTotalAmount.text = "--"
        
        lblVat.addTapGesture { [self] in
            performSegue(withIdentifier: "toEditVAT", sender: nil)
            //navigateToSecondViewController()
        }
        
        lblDiscount.addTapGesture { [self] in
            performSegue(withIdentifier: "toEditDiscount", sender: nil)
        }
        
       
        updateButtonDateTitle()
        resetOptionMenu()
        
        lblAddLedger.addTapGesture {[self] in
            actionAddDiscount()
            resetOptionMenu()
        }
        
        lblAddInventory.addTapGesture {[self] in
            actionAddInventory()
            resetOptionMenu()
        }
    }
    
    func resetOptionMenu()
    {
        self.menuHeightConstraint.constant = 0
        isBottomViewExpanded = false
    }
    
    func actionAddInventory() {
       performSegue(withIdentifier: "addInventory", sender: nil)
   }
    
    func actionAddDiscount() {
        print("to add discount")
        
        performSegue(withIdentifier: "toAddDiscount", sender: nil)
    }
    
    private func updateButtonDateTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "  dd/MM/yyyy" // Specify the desired date format
        let formattedDate = dateFormatter.string(from: Date())
        
        btnDateSelecting.setTitle(formattedDate, for: .normal)
    }
    
    func navigateToSecondViewController() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let secondVC = storyboard.instantiateViewController(withIdentifier: "BottomSheetValueEditingVC") as? BottomSheetValueEditingVC {
                secondVC.callBack = { [weak self] firstValue, secondValue in
                   print("getting: \(firstValue), \(secondValue)")
                }
                secondVC.modalPresentationStyle = .formSheet
                navigationController?.pushViewController(secondVC, animated: true)
            } else {
                print("Failed to instantiate SecondViewController from storyboard.")
            }
        }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "addInventory"
        {
            if let vc = segue.destination as? ChooseProductVC{
               // Step 1 //  assign Another class's vc
                vc.newProductAdded =  { productModel in //Step 4
                    self.arrSelectedProducts.append(MainProductModel(id: productModel.id ?? 0, selectedProduct: productModel))
                    
                }
                
                
            }
        }
        else  if segue.identifier == "editInventory"
        {
            
            if let index = sender as? Int {
                print("getting index: \(index)")
                
                if let vc = segue.destination as? ChooseProductVC
                {
                    vc.editableProductModel = arrSelectedProducts[index].selectedProduct
                    vc.tappedIndex = index
                    vc.sameProductEdited =  { productModel in //Step 4
                        
                        self.arrSelectedProducts[index] = MainProductModel(id: productModel.id ?? 0, selectedProduct: productModel)

                        
                    }
                }
                
                
            }
            else
            {
                print("index sender is nil")
            }
        }
        else  if segue.identifier == "toAddDiscount"
        {
            
            if let vc = segue.destination as? AddDiscountVC
            {
                var amountDouble = Double(lblTotalAmount.text ?? "0.0") ?? 0.0
                vc.totalAmount = (amountDouble * 10 ) / 100
                vc.ledgerApplied =  { ledgerModel in
                    
                   print("ledger applied: \(ledgerModel as Any)")
                    var prodLedgeModel = ProductModel()
                    prodLedgeModel.id = 0
                    prodLedgeModel.ledgerType = ledgerModel
                    prodLedgeModel.pName = ledgerModel.ledgerType
                    prodLedgeModel.amount = ledgerModel.amount
                    prodLedgeModel.price = ledgerModel.amount
                    
                    
                   
                    
                    self.arrSelectedProducts.append(MainProductModel(id: 0, selectedProduct: prodLedgeModel))
                    self.tableView.reloadData()
                    
                }
            }
        }
        else if segue.identifier == "toEditDiscount"
          {
              if let vc = segue.destination as? BottomSheetValueEditingVC{
                  vc.headingString = "Edit Discount"
                 // Step 1 //  assign Another class's vc
                  vc.callBack = { [weak self] firstValue, discountDouble in
                      print("getting: " + firstValue.description + discountDouble.description)
                      self?.lblDiscount.text = discountDouble.description
                      
                      var amountDouble = Double(self?.lblTotalAmount.text ?? "0.0") ?? 0.0
                      self?.lblTotalAmount.text = (amountDouble - (amountDouble / discountDouble)).description
                      vc.dismiss(animated: true)
                  }
                  
              }
          }
        
        else if segue.identifier == "toEditVAT"
          {
              if let vc = segue.destination as? BottomSheetValueEditingVC{
                  vc.headingString = "Edit VAT"
                 // Step 1 //  assign Another class's vc
                  vc.callBack = { [weak self] firstValue, vatDouble in
                      print("getting: " + firstValue.description + vatDouble.description)
                      self?.lblVat.text = vatDouble.description
                      
                      var amountDouble = Double(self?.lblTotalAmount.text ?? "0.0") ?? 0.0
                      self?.lblTotalAmount.text = (amountDouble + (amountDouble / vatDouble)).description
                      vc.dismiss(animated: true)
                  }
                  
                  
              }
          }
    }
    
    @IBAction func actionChooseDate(_ sender: Any) {
           let datePickerVC = DatePickerViewController()
           
           // Present as a bottom sheet modal
           if let sheet = datePickerVC.sheetPresentationController {
               sheet.detents = [.medium()] // Present as a medium height bottom sheet
               sheet.preferredCornerRadius = 16 // Optional: Rounded corners for the sheet
           }
           
           datePickerVC.onDateSelected = { [weak self] selectedDate in
               let dateFormatter = DateFormatter()
               dateFormatter.dateStyle = .medium
               let dateString = dateFormatter.string(from: selectedDate)
               self?.btnDateSelecting.setTitle(dateString, for: .normal)
           }
           
           present(datePickerVC, animated: true, completion: nil)
       }
    
}

extension DashboardProductsVC : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductMainCell", for: indexPath) as? ProductMainCell
        
        cell?.lblName.text = "\(arrSelectedProducts[indexPath.row].selectedProduct.pName)"
        
        cell?.lblQuantity.text = "\(arrSelectedProducts[indexPath.row].selectedProduct.qty ?? 0)"
        
        cell?.lblRate.text = "$\(arrSelectedProducts[indexPath.row].selectedProduct.price)"
        
        cell?.lblUnit.text = "\(arrSelectedProducts[indexPath.row].selectedProduct.inStock)"
        
        cell?.lblAmount.text = "$\(arrSelectedProducts[indexPath.row].selectedProduct.amount ?? 0)"
        
        cell?.btnEditTapped =
        {
            print("called \(indexPath.row)")
            self.performSegue(withIdentifier: "editInventory", sender: indexPath.row)
        }
        
        cell?.btnDeleteTapped =
        { [self] in
            print("called \(indexPath.row)")
            arrSelectedProducts.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderViewCell") as! HeaderViewCell
           
           // Set the frame for the header cell to match the header view
           headerCell.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44) // Adjust the height as needed
           
           // Add header cell to header view
           headerView.addSubview(headerCell)
           
           return headerView
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedProducts.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped: \(indexPath.row)")
       
    }

}



class DatePickerViewController: UIViewController {

    var datePicker: UIDatePicker!
    var onDateSelected: ((Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        // Setup the date picker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(datePicker)
        
        // Setup the toolbar with a "Done" button
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        view.addSubview(toolbar)
        
        // Layout constraints for the date picker and toolbar
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: view.topAnchor),
            
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func donePressed() {
        onDateSelected?(datePicker.date)
        dismiss(animated: true, completion: nil)
    }
}

extension DashboardProductsVC
{
    @objc func showActionSheet() {
        // Create the action sheet
        let actionSheet = UIAlertController(title: "Choose an Option", message: "Please select one of the following options", preferredStyle: .actionSheet)

        // Add 5 actions
        actionSheet.addAction(UIAlertAction(title: "Add Ledger", style: .default, handler: {  _ in
            print("Option 1 selected")
            self.actionAddDiscount()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Add Inventory", style: .default, handler: {[weak self] _ in
            print("Option 2 selected")
            self?.actionAddInventory()
        }))
        
     
        // Add a cancel action
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("Cancel selected")
        }))

        // Present the action sheet
        self.present(actionSheet, animated: true, completion: nil)
    }
}
