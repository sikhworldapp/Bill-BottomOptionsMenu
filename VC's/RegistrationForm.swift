//
//  ViewController.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 27/05/24.
//

import UIKit

class RegistrationForm: BaseViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
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
        initDate()
        initTime()
        btnSubmit.addTapGesture {
            self.submitForm()
           
        }
        
        imgEye.addTapGesture {
            self.togglePasswordVisibility()
        }
        txtEmail.delegate = self
        txtUsername.delegate = self
        txtPassword.delegate = self
    }
    
    func initDate()
    {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        datePicker?.preferredDatePickerStyle = .wheels
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Example: 1 year ago from today as the minimum date
        let minDate = calendar.date(byAdding: .year, value: -1, to: currentDate)
        
        // Example: 1 year ahead from today as the maximum date
        let maxDate = calendar.date(byAdding: .year, value: 1, to: currentDate)
        
        datePicker?.minimumDate = minDate
        datePicker?.maximumDate = maxDate
        txtDate.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressedForDate))
        toolbar.setItems([doneButton], animated: true)
        
        txtDate.inputAccessoryView = toolbar
        
        // Set a default date (optional)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        txtDate.text = dateFormatter.string(from: Date())
    }
    
    @objc func donePressedForDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        // Format the selected date and set it as the text of txtDate
        txtDate.text = dateFormatter.string(from: datePicker?.date ?? Date())
        
        // Dismiss the date picker
        self.view.endEditing(true)
    }
    
    //for time:
    
    func initTime() {
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.preferredDatePickerStyle = .wheels
        
        // Set the locale to ensure AM/PM format (en_US_POSIX is a common choice)
        timePicker?.locale = Locale(identifier: "en_US_POSIX")
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Set the minimum time to 8:00 AM
        var minComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
        minComponents.hour = 8
        minComponents.minute = 0
        let minTime = calendar.date(from: minComponents)
        
        // Set the maximum time to 10:00 PM
        var maxComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
        maxComponents.hour = 22  // 10:00 PM
        maxComponents.minute = 0
        let maxTime = calendar.date(from: maxComponents)
        
        timePicker?.minimumDate = minTime
        timePicker?.maximumDate = maxTime
        
        txtTime.inputView = timePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressedForTime))
        toolbar.setItems([doneButton], animated: true)
        
        txtTime.inputAccessoryView = toolbar
        
        // Set a default time (optional)
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")  // Ensure AM/PM format
        txtTime.text = timeFormatter.string(from: currentDate)
    }
    
    @objc func donePressedForTime() {
        if let timePicker = timePicker {
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            timeFormatter.locale = Locale(identifier: "en_US_POSIX")  // Ensure AM/PM format
            txtTime.text = timeFormatter.string(from: timePicker.date)
        }
        
        txtTime.resignFirstResponder()
    }
    
}

extension RegistrationForm: UITextFieldDelegate
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
           } else if textField == txtUsername {
               // Allowable characters in username (letters, numbers, underscore, and hyphen)
               let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
               let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
               let typedCharacterSet = CharacterSet(charactersIn: string)
               
               // Check if the typed characters are in the allowed set
               if !allowedCharacterSet.isSuperset(of: typedCharacterSet) {
                   return false
               }
               
               // Optionally, you can add further validation for username, e.g., length, starting character, etc.
               textField.textColor = .black
           } else if textField == txtPassword {
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
            
               
               var model = UserProfileModel(username: /txtUsername.text,
                                            email: /txtEmail.text,
                                            password: /txtPassword.text,
                                            Date: /txtDate.text,
                                            Time: /txtTime.text)
               showProgress()
               NetworkManagerService.shared.userRegistration(userModel: model) { [self] result in
                   switch result
                   {
                   case .success(let response):
                       
                           print("getting response: \(response.message)")
                       if response.status == "true"
                       {
                           UserDefaults.standard.setValue(true,forKey: AppConstants.shared.isLoggedIn)
                           DispatchQueue.main.async{
                               self.performSegue(withIdentifier: "toDashboard", sender: nil)
                           }
                           
                           
                       }
                       else
                       {
                           DispatchQueue.main.async{
                               let storyboard = UIStoryboard(name: "Main", bundle: nil)
                               if let newViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                                   newViewController.modalPresentationStyle = .fullScreen // or .overFullScreen for a transparent background
                                   present(newViewController, animated: true, completion: nil)
                               }
                               
                             
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
           return appConstants.isValidEmail(txtEmail.text!) && !txtUsername.text!.isEmpty && appConstants.isValidPassword(txtPassword.text!)
       }
}
