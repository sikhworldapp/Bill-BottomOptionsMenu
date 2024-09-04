//
//  ChooseProductVC.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 04/07/24.
//

import UIKit
import SVProgressHUD

class AddNewProductNetworkVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfProdName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var btnAddEditDel: UIButton!
    @IBOutlet weak var imgAddImage: UIImageView!
    @IBOutlet weak var imgProdImage: UIImageView!
    @IBOutlet weak var lblHeadingAddNewPro: UILabel!
    @IBOutlet weak var lblAddNewItem: UILabel!
    
    var isDataSaved : (()->())? = nil
    
    var tappedIndex = 0
    
    var crossImg = UIImage(systemName: "xmark.circle.fill")
    var downArrowImg = UIImage(systemName: "arrow.down.circle.fill")
    var newProductAdded: ((ProductModel) ->())? = nil //will be set from previous vc..already displaying..
    var sameProductEdited: ((ProductModel) ->())? = nil //will be set from previous vc..already displaying.
    
    var prefs = UserDefaults.standard
    var encodedImgData : Data? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeadingAddNewPro.text = NSLocalizedString("add_new_product", comment: "")
        lblAddNewItem.text = NSLocalizedString("Add new item", comment: "")
        
        imgAddImage.addTapGesture {
            SVProgressHUD.show()
            self.openGallery()
        }
        
        checkLogicSavingProducts()
        tfPrice.delegate = self
        tfProdName.delegate = self
        view.addTapGesture {
            self.tfPrice.resignFirstResponder()
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == tfProdName
//        {
//            if textField.text?.count ?? 0 > 2
//            {
//                return false
//            }
//        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    @IBAction func actionAddNewItem(_ sender: Any) {
        if let name = tfProdName.text, name.count > 0, let price = tfPrice.text, price.count > 0
        {
            if imgProdImage.image != nil
            {
                print("with image.")
                postProductHitApi(model: Product(id: "", name: name, price: price, date: AppConstants.shared.getCurrentDate()))
            }
            else
            { 
                print("hitting wihtout iamge ")
                var arrProducts = [Product]()
                let prod = Product(id: "", name: name, price: price, date: AppConstants.shared.getCurrentDate())
                arrProducts.append(prod)
                postMultiProductsHitApi(models: arrProducts)
            }
        }
        else
        {
            showToastMsg("Please fill all the fields correctly.", msg: "", position: .bottom)
        }
    }
    
    func postProductHitApi(model: Product) {
        
        showProgress("Adding...")
        
        // Adjust compressionQuality as needed
        NetworkManagerService.shared.addProductWithImage(product: model, image: imgProdImage.image!) { [self] result in
            switch result {
            case .success(let response):
                print("Response: \(response)")
                if response.status == "true" {
                    print("Success: \(response.message)")
                    
                    DispatchQueue.main.async
                    { [self] in
                        showToastMsg("Saved successfully.", msg: "", position: .bottom)
                        dismiss(animated: true)
                        navigationController?.popViewController(animated: true)
                        isDataSaved?()
                    }
                    
                    // Handle success, update UI, etc.
                } else {
                    print("Failed: \(response.message)")
                    DispatchQueue.main.async
                    { [self] in
                        self.showAlertMsg(title: "Issue", message: response.message)
                    }
                    
                    // Handle failure, show an error message
                }
            case .failure(let error):
                print("Failed to add product: \(error)")
                DispatchQueue.main.async
                { [self] in
                    showToastMsg(error.localizedDescription, msg: "", position: .bottom)
                }
                // Handle error, show an alert, etc.
            }
            hideProgress()
        }
    }
    
    func postMultiProductsHitApi(models: [Product]) {
        showProgress("Adding...")
        
        NetworkManagerService.shared.addMultiProducts(products: models) { [self] result in
            switch result {
            case .success(let response):
                print("Response: \(response)")
                if response.status == "true" {
                    print("Success: \(response.message)")
                    
                    DispatchQueue.main.async
                    { [self] in
                        showToastMsg("Saved successfully.", msg: "", position: .bottom)
                        dismiss(animated: true)
                        navigationController?.popViewController(animated: true)
                        isDataSaved?()
                    }
                   
                    // Handle success, update UI, etc.
                } else {
                    print("Failed: \(response.message)")
                    DispatchQueue.main.async
                    { [self] in
                        self.showAlertMsg(title: "Issue", message: response.message)
                    }
                    
                    // Handle failure, show an error message
                }
            case .failure(let error):
                print("Failed to add product: \(error)")
                DispatchQueue.main.async
                { [self] in
                    showToastMsg(error.localizedDescription, msg: "", position: .bottom)
                }
                // Handle error, show an alert, etc.
            }
            hideProgress()
        }
    }
    

    
    @objc func openGallery() {
        // Check if the photo library is available
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Photo library not available")
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        
        
        
        present(imagePickerController, animated: true) { [weak self] in
            // Stop the activity indicator after the image picker is presented
            SVProgressHUD.dismiss()
        }
    }
    
    func checkLogicSavingProducts()
    {
        if prefs.bool(forKey: "isProductsSaved")
        {
            print("fetch from local db then")
        }
        else
        {
            print("save all products into core data..")
            let allProds = AppConstants.shared.loadProducts()
            for i in allProds
            {
                
                CoreDataStack.shared.insertProduct(model: i)
            }
            prefs.setValue(true, forKey: "isProductsSaved")
            
        }
    }
}

extension AddNewProductNetworkVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // Get the selected image
        if let selectedImage = info[.originalImage] as? UIImage {
            imgProdImage.image = selectedImage
            
            
            if let imageData = selectedImage.pngData() {
                encodedImgData = imageData
                
                
            }
        }
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
