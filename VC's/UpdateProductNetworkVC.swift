//
//  ChooseProductVC.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 04/07/24.
//

import UIKit
import SVProgressHUD

class UpdateProductNetworkVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfProdName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var btnAddEditDel: UIButton!
    @IBOutlet weak var imgAddImage: UIImageView!
    @IBOutlet weak var imgProdImage: UIImageView!
    @IBOutlet weak var imgCross: UIImageView!
    @IBOutlet weak var lblHeadingAddNewPro: UILabel!
    @IBOutlet weak var lblAddNewItem: UILabel!
    
    var editableProductModel : Item? = nil
    var itemUpdated : (()->())? = nil
    
    var tappedIndex = 0
    
    var crossImg = UIImage(systemName: "xmark.circle.fill")
    var downArrowImg = UIImage(systemName: "arrow.down.circle.fill")
    var newProductAdded: ((Item) ->())? = nil //will be set from previous vc..already displaying..
    var sameProductEdited: ((Item) ->())? = nil //will be set from previous vc..already displaying.
    
    var prefs = UserDefaults.standard
    var encodedImgData : Data? = nil
    var originalPname = ""
    var receivingModel : Item? = nil
    let viewModel = UpdateServicesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var x = editableProductModel
      /*  if let model = editableProductModel
        {
            tfProdName.text = model.name
            originalPname = model.name ?? ""
            tfPrice.text = model.price?.description
//            if let dataThere = model.imageData
//            {
//                imgProdImage.image = UIImage(data: dataThere)
//                imgCross.isHidden = false
//            }
            
            
        }
       */
        
        getNameResponseFromViewModel()//fetching from backend api
        
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
        
        imgCross.addTapGesture { [weak self] in
            self?.imgProdImage.image = nil
            self?.imgCross.isHidden = true
        }
     }
    
    func getNameResponseFromViewModel()
    {
        showProgress()
        viewModel.getNameResponse(name: editableProductModel?.name ?? "" ,
                                  id: editableProductModel?.id ?? "") { someResponseModel, errorString in
            DispatchQueue.main.async
            { [self] in
                if let modelFromBackend = someResponseModel
                {
                    showToastMsg("Got successfully.", msg: "", position: .bottom)
                    tfProdName.text = modelFromBackend.data?.name
                    tfPrice.text = modelFromBackend.data?.price
                    let urlString = "\(NetworkManagerService.shared.domainName)/Images/\(modelFromBackend.data?.image ?? "")"
                    imgProdImage.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "noImageFound"))
                }
                else
                {
                    showToastMsg(errorString!, msg: "", position: .bottom)
                }
                hideProgress()
            }
        }
    }
    
    func getNameResponse() {
        showProgress("Getting by Name")
        
        NetworkManagerService.shared.getProductJson(name: editableProductModel?.name, id: editableProductModel?.id) { [self] result in
            switch result {
            case .success(let response):
             
                if response.status == "true" {
                    print("Success: \(response.message)")
                    print("getting response: \(response.data as Any)")
                    
                   if let modelFromBackend: ProductWithImage = response.data
                   {
                       DispatchQueue.main.async
                       { [self] in
                           showToastMsg("Got successfully.", msg: "", position: .bottom)
                           tfProdName.text = modelFromBackend.name
                           tfPrice.text = modelFromBackend.price
                           
                           
                       }
                   }
           
                    // Handle success, update UI, etc.
                } else {
                    print("Failed: \(response.message)")
                    DispatchQueue.main.async
                    { [self] in
                        self.showAlertMsg(title: "Issue", message: response.message ?? "")
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
    
    @IBAction func actionUpdateItem(_ sender: Any) {
        showProgress("Updating")
        var product = Product(id: editableProductModel?.id ?? "",
                              name: tfProdName.text ?? "",
                              price: tfPrice.text ?? "",
                              date: AppConstants.shared.getCurrentDate())
        
        NetworkManagerService.shared.updateProduct(product: product) { [self] result in
            switch result {
            case .success(let response):
             
                if response.status == "true" {
                    print("Success: \(response.message)")
                    
                    DispatchQueue.main.async
                    { [self] in
                        showToastMsg("Update successfully.", msg: "", position: .bottom)
                        finish()
                        
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
            itemUpdated?()
        }
     }
    
    @IBAction func actionDeleteItem(_ sender: Any) {
        AppConstants.shared.showAlert(on: self, with: "Do you want to delete : \(originalPname)") { [weak self] in
            self?.hitDeleteApi()
            
        } noAction: {
            print("no tapped.")
        }
    }
    
    func hitDeleteApi()
    {
        showProgress("Deleting")
        var product = Product(id: editableProductModel?.id ?? "",
                              name: tfProdName.text ?? "",
                              price: tfPrice.text ?? "",
                              date: AppConstants.shared.getCurrentDate())
        
        NetworkManagerService.shared.deleteProduct(product: product) { [self] result in
            switch result {
            case .success(let response):
             
                if response.status == "true" {
                    print("Success: \(response.message)")
                    
                    DispatchQueue.main.async
                    { [self] in
                        showToastMsg("Deleted successfully.", msg: "", position: .bottom)
                        finish()
                        
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
            itemUpdated?()
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
        
        present(imagePickerController, animated: true){
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

extension UpdateProductNetworkVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // Get the selected image
        if let selectedImage = info[.originalImage] as? UIImage {
            imgProdImage.image = selectedImage
            imgCross.isHidden = false
            
            if let imageData = selectedImage.pngData() {
                encodedImgData = imageData
                
                
            }
        }
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
