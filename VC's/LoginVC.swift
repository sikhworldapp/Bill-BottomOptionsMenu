//
//  ViewController.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 27/05/24.
//

import UIKit

class LoginVC: BaseViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var imgEye: UIImageView!
    
    private var datePicker: UIDatePicker?
    private var timePicker: UIDatePicker?
    
    var isPasswordVisible = false
    let appConstants = AppConstants.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: appConstants.isLoggedIn)
        {
            self.performSegue(withIdentifier: "toDashboard", sender: nil)
        }
       
        btnSubmit.addTapGesture {
            self.submitForm()
           
        }
        
        imgEye.addTapGesture {
            self.togglePasswordVisibility()
        }
        txtEmail.delegate = self
        txtPassword.delegate = self
    }
}

extension LoginVC: UITextFieldDelegate
{
    // UITextFieldDelegate method to handle text changes
    // UITextFieldDelegate method to handle text changes
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
           if textField == txtEmail {
               // Allowable characters in email
               let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.-_"
               let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
               let typedCharacterSet = CharacterSet(charactersIn: string)
               
               // Check if the typed characters are in the allowed set
               if !allowedCharacterSet.isSuperset(of: typedCharacterSet) {
                   return false
               }
               
               // Construct the potential new string
               let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
               
               // Validate email format (basic validation)
               if appConstants.isValidEmail(newString) {
                   textField.textColor = .black
               } else {
                   textField.textColor = .red
               }
           }  else if textField == txtPassword {
               // Allowable characters in password (letters, numbers, special characters)
               let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{}|;:'\",.<>?/"
               let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
               let typedCharacterSet = CharacterSet(charactersIn: string)
               
               // Check if the typed characters are in the allowed set
               if !allowedCharacterSet.isSuperset(of: typedCharacterSet) {
                   return false
               }
               
               // Construct the potential new string
               let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
               
               // Optionally, validate password strength or other criteria
               if appConstants.isValidPassword(newString) {
                   textField.textColor = .black
               } else {
                   textField.textColor = .red
               }
           }
           
           return true
       }
    
    @objc func togglePasswordVisibility() {
           // Toggle the password visibility
           isPasswordVisible.toggle()
           
           // Update the text field's secure entry status
           txtPassword.isSecureTextEntry = !isPasswordVisible
           
           // Update the eye image based on the password visibility
           updateEyeImage()
       }
       
       func updateEyeImage() {
           // Set the system image for the eye icon
           let imageName = isPasswordVisible ? "eye" : "eye.slash"
           imgEye.image = UIImage(systemName: imageName)
       }
       
    @objc func submitForm() {
           if areFieldsValid() {
               // Perform segue to the Dashboard
            
               
               var model = LoginModel(      email: /txtEmail.text,
                                            password: /txtPassword.text
                                      )
               showProgress()
               NetworkManagerService.shared.userLogin(userModel: model) {[self] result in
                   switch result
                   {
                   case .success(let response):
                       
                           print("getting response: \(response.message)")
                       if response.status == "true"
                       {
                           prefs.setValue(true, forKey: AppConstants.shared.isLoggedIn)
                           appConstants.saveLoginResponseToUserDefaults(response)
                           DispatchQueue.main.async{
                               self.performSegue(withIdentifier: "toDashboard", sender: nil)
                           }
                           
                           
                       }
                    
                   case .failure(let error):
                           print("getting error: \(error.localizedDescription)")
                   }
                   self.hideProgress()
                   
               }
           } else {
               // Optionally, show an alert or feedback to the user
               showAlert(title: "Please fill in all fields correctly.", message: "")
           }
       }
       
       func areFieldsValid() -> Bool {
           // Check if all fields are non-empty and valid
           return appConstants.isValidEmail(txtEmail.text!)  && appConstants.isValidPassword(txtPassword.text!)
       }
}
