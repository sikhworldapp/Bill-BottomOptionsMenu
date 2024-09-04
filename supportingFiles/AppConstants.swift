//
//  AppConstants.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 19/06/24.
//

import UIKit

let prefs = UserDefaults.standard

class AppConstants
{
    static var shared = AppConstants() //new
    let isLoggedIn = "isLoggedIn"
    private init(){
        print("initialized")
    }
    
    func loadStudentData() -> [ProductModel]
    {
        var arrProducts = [ProductModel]()
        var prod1 = ProductModel(id: 0, pName: "Glister Paste", price: 3.5, inStock: 10, addedByCustomer: 0)
        var prod2 = ProductModel(id: 1, pName: "Sanitizer", price: 6.5, inStock: 5, addedByCustomer: 0)
        var prod3 = ProductModel(id: 2, pName: "Hand wash", price: 2.5, inStock: 20, addedByCustomer: 0)
        
        
        arrProducts.append(prod1)
        arrProducts.append(prod2)
        arrProducts.append(prod3)
        
        return arrProducts
    }
    
    func saveLoginResponseToUserDefaults(_ response: LoginResponse) {
        let defaults = UserDefaults.standard
        
        do {
            // Encode the LoginResponse to Data
            let encodedData = try JSONEncoder().encode(response)
            
            // Save the encoded data to UserDefaults
            defaults.set(encodedData, forKey: "loginResponse")
            
            print("Login response saved successfully")
        } catch {
            print("Failed to encode login response: \(error)")
        }
    }
    
    func clearUserDefaults(completion: @escaping () -> Void) {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize() // Force the UserDefaults to save the changes
        }
        
        // Call the completion block after clearing user defaults
        completion()
    }


    
    func loadLoginResponseFromUserDefaults() -> LoginResponse? { // data > json > decode > model
        let defaults = UserDefaults.standard
        
        // Retrieve the data from UserDefaults
        if let savedData = defaults.data(forKey: "loginResponse") {
            do {
                // Decode the data back into LoginResponse
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: savedData)
                return decodedResponse
            } catch {
                print("Failed to decode login response: \(error)")
                return nil
            }
        }
        
        return nil
    }


    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let todayDate = Date()
        return dateFormatter.string(from: todayDate)
    }
 
    func getDashboardOptions() -> [IconTitle]
    {
        var arrOptions = [IconTitle]()
        arrOptions.append(IconTitle(title: "Add Item", img: UIImage(systemName: "plus.circle")!))
        arrOptions.append(IconTitle(title: "Item List", img: UIImage(systemName: "list.bullet")!))
        arrOptions.append(IconTitle(title: "Billing", img: UIImage(systemName: "person.circle")!))
        
       return arrOptions
    }
    
    
    func showAlert(on viewController: UIViewController, with message: String, yesAction: @escaping () -> Void, noAction: @escaping () -> Void) {
          let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
          
          let yesButton = UIAlertAction(title: "Yes", style: .default) { _ in
              yesAction()
          }
          
          let noButton = UIAlertAction(title: "No", style: .cancel) { _ in
              noAction()
          }
          
          alert.addAction(yesButton)
          alert.addAction(noButton)
          
          viewController.present(alert, animated: true, completion: nil)
      }
    
    // Function to validate password strength (basic validation)
       func isValidPassword(_ password: String) -> Bool {
           // Example criteria: At least 8 characters, contains at least one letter and one number
           let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d!@#$%^&*()-_=+\\[\\]{}|;:'\",.<>?/]{8,}$"
           let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
           return passwordPredicate.evaluate(with: password)
       }
    
    // Function to validate email format (basic validation)
    func isValidEmail(_ email: String) -> Bool {
        // Basic regex for validating email format
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
   
    
    func loadProducts() -> [ProductModel]
    {
        return []
        /* let products = [
            ProductModel(id: 0, pName: "Glister Paste", price: 3.514, inStock: 10, addedByCustomer: 0),
            ProductModel(id: 1, pName: "Sanitizer", price: 6.5, inStock: 5, addedByCustomer: 0),
            ProductModel(id: 3, pName: "Apple", price: 1.2, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 4, pName: "Banana", price: 0.5, inStock: 100, addedByCustomer: 0),
            ProductModel(id: 5, pName: "Orange", price: 1.1, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 6, pName: "Milk", price: 2.5, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 7, pName: "Bread", price: 1.5, inStock: 15, addedByCustomer: 0),
            ProductModel(id: 8, pName: "Eggs", price: 3.0, inStock: 60, addedByCustomer: 0),
            ProductModel(id: 9, pName: "Cheese", price: 4.0, inStock: 10, addedByCustomer: 0),
            ProductModel(id: 10, pName: "Butter", price: 3.2, inStock: 25, addedByCustomer: 0),
            ProductModel(id: 11, pName: "Yogurt", price: 2.0, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 12, pName: "Chicken Breast", price: 5.5, inStock: 10, addedByCustomer: 0),
           ProductModel(id: 2, pName: "Hand wash", price: 2.5, inStock: 20, addedByCustomer: 0),
           
            ProductModel(id: 13, pName: "Ground Beef", price: 7.0, inStock: 8, addedByCustomer: 0),
            ProductModel(id: 14, pName: "Salmon", price: 12.0, inStock: 6, addedByCustomer: 0),
            ProductModel(id: 15, pName: "Pasta", price: 1.8, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 16, pName: "Rice", price: 1.0, inStock: 40, addedByCustomer: 0),
            ProductModel(id: 17, pName: "Olive Oil", price: 5.0, inStock: 12, addedByCustomer: 0),
            ProductModel(id: 18, pName: "Salt", price: 0.8, inStock: 100, addedByCustomer: 0),
            ProductModel(id: 19, pName: "Pepper", price: 1.2, inStock: 80, addedByCustomer: 0),
            ProductModel(id: 20, pName: "Sugar", price: 2.0, inStock: 60, addedByCustomer: 0),
            ProductModel(id: 21, pName: "Flour", price: 1.5, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 22, pName: "Baking Soda", price: 0.9, inStock: 40, addedByCustomer: 0),
            ProductModel(id: 23, pName: "Vinegar", price: 1.3, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 24, pName: "Honey", price: 3.5, inStock: 25, addedByCustomer: 0),
            ProductModel(id: 25, pName: "Peanut Butter", price: 4.0, inStock: 15, addedByCustomer: 0),
            ProductModel(id: 26, pName: "Jam", price: 3.0, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 27, pName: "Ketchup", price: 2.5, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 28, pName: "Mustard", price: 1.5, inStock: 40, addedByCustomer: 0),
            ProductModel(id: 29, pName: "Mayonnaise", price: 3.0, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 30, pName: "Lettuce", price: 1.0, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 31, pName: "Tomato", price: 1.2, inStock: 40, addedByCustomer: 0),
            ProductModel(id: 32, pName: "Cucumber", price: 1.0, inStock: 60, addedByCustomer: 0),
            ProductModel(id: 33, pName: "Bell Pepper", price: 1.5, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 34, pName: "Carrot", price: 0.8, inStock: 70, addedByCustomer: 0),
            ProductModel(id: 35, pName: "Broccoli", price: 1.8, inStock: 25, addedByCustomer: 0),
            ProductModel(id: 36, pName: "Spinach", price: 2.0, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 37, pName: "Potato", price: 0.6, inStock: 100, addedByCustomer: 0),
            ProductModel(id: 38, pName: "Onion", price: 0.5, inStock: 80, addedByCustomer: 0),
            ProductModel(id: 39, pName: "Garlic", price: 1.0, inStock: 60, addedByCustomer: 0),
            ProductModel(id: 40, pName: "Ginger", price: 1.2, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 41, pName: "Celery", price: 1.5, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 42, pName: "Mushroom", price: 2.5, inStock: 25, addedByCustomer: 0),
            ProductModel(id: 43, pName: "Green Bean", price: 1.8, inStock: 40, addedByCustomer: 0),
            ProductModel(id: 44, pName: "Zucchini", price: 1.0, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 45, pName: "Eggplant", price: 1.5, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 46, pName: "Pumpkin", price: 2.0, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 47, pName: "Cabbage", price: 1.2, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 48, pName: "Cauliflower", price: 1.5, inStock: 25, addedByCustomer: 0),
            ProductModel(id: 49, pName: "Corn", price: 1.0, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 50, pName: "Apple Juice", price: 3.0, inStock: 15, addedByCustomer: 0),
            ProductModel(id: 51, pName: "Orange Juice", price: 3.5, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 52, pName: "Grape Juice", price: 4.0, inStock: 10, addedByCustomer: 0),
            ProductModel(id: 53, pName: "Lemonade", price: 2.5, inStock: 25, addedByCustomer: 0),
            ProductModel(id: 54, pName: "Iced Tea", price: 2.0, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 55, pName: "Coffee", price: 5.0, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 56, pName: "Tea", price: 3.0, inStock: 25, addedByCustomer: 0),
            ProductModel(id: 57, pName: "Hot Chocolate", price: 2.5, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 58, pName: "Soda", price: 1.0, inStock: 100, addedByCustomer: 0),
            ProductModel(id: 59, pName: "Sparkling Water", price: 1.5, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 60, pName: "Energy Drink", price: 2.0, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 61, pName: "Beer", price: 3.0, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 62, pName: "Wine", price: 10.0, inStock: 15, addedByCustomer: 0),
            ProductModel(id: 63, pName: "Whiskey", price: 20.0, inStock: 10, addedByCustomer: 0),
            ProductModel(id: 64, pName: "Vodka", price: 15.0, inStock: 12, addedByCustomer: 0),
            ProductModel(id: 65, pName: "Gin", price: 18.0, inStock: 8, addedByCustomer: 0),
            ProductModel(id: 66, pName: "Rum", price: 16.0, inStock: 10, addedByCustomer: 0),
            ProductModel(id: 67, pName: "Champagne", price: 25.0, inStock: 5, addedByCustomer: 0),
            ProductModel(id: 68, pName: "Toilet Paper", price: 0.5, inStock: 200, addedByCustomer: 0),
            ProductModel(id: 69, pName: "Paper Towels", price: 1.0, inStock: 100, addedByCustomer: 0),
            ProductModel(id: 70, pName: "Facial Tissue", price: 1.2, inStock: 80, addedByCustomer: 0),
            ProductModel(id: 71, pName: "Shampoo", price: 5.0, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 72, pName: "Conditioner", price: 5.0, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 73, pName: "Body Wash", price: 4.0, inStock: 40, addedByCustomer: 0),
            ProductModel(id: 74, pName: "Lotion", price: 6.0, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 75, pName: "Toothpaste", price: 3.0, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 76, pName: "Toothbrush", price: 2.0, inStock: 60, addedByCustomer: 0),
            ProductModel(id: 77, pName: "Mouthwash", price: 4.5, inStock: 25, addedByCustomer: 0),
            ProductModel(id: 78, pName: "Deodorant", price: 3.5, inStock: 40, addedByCustomer: 0),
            ProductModel(id: 79, pName: "Razor", price: 2.5, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 80, pName: "Shaving Cream", price: 3.0, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 81, pName: "Laundry Detergent", price: 10.0, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 82, pName: "Fabric Softener", price: 6.0, inStock: 25, addedByCustomer: 0),
            ProductModel(id: 83, pName: "Dish Soap", price: 2.5, inStock: 40, addedByCustomer: 0),
            ProductModel(id: 84, pName: "All-Purpose Cleaner", price: 3.5, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 85, pName: "Window Cleaner", price: 3.0, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 86, pName: "Trash Bags", price: 4.0, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 87, pName: "Aluminum Foil", price: 2.5, inStock: 40, addedByCustomer: 0),
            ProductModel(id: 88, pName: "Plastic Wrap", price: 2.0, inStock: 60, addedByCustomer: 0),
            ProductModel(id: 89, pName: "Ziploc Bags", price: 3.0, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 90, pName: "Sponges", price: 1.5, inStock: 70, addedByCustomer: 0),
            ProductModel(id: 91, pName: "Batteries", price: 4.5, inStock: 40, addedByCustomer: 0),
            ProductModel(id: 92, pName: "Light Bulbs", price: 2.5, inStock: 50, addedByCustomer: 0),
            ProductModel(id: 93, pName: "Extension Cord", price: 5.0, inStock: 20, addedByCustomer: 0),
            ProductModel(id: 94, pName: "Power Strip", price: 6.0, inStock: 15, addedByCustomer: 0),
            ProductModel(id: 95, pName: "Phone Charger", price: 10.0, inStock: 25, addedByCustomer: 0),
            ProductModel(id: 96, pName: "USB Cable", price: 3.0, inStock: 40, addedByCustomer: 0),
            ProductModel(id: 97, pName: "HDMI Cable", price: 8.0, inStock: 30, addedByCustomer: 0),
            ProductModel(id: 98, pName: "Mouse", price: 12.0, inStock: 15, addedByCustomer: 0),
            ProductModel(id: 99, pName: "Keyboard", price: 20.0, inStock: 10, addedByCustomer: 0),*/
        //]
        
        
        //return products
        
        
    }
    
    func loadLedger() -> [LedgerModel]
    {
        let arrLedger = [LedgerModel(ledgerType: "Discount", amount: 0),
                         LedgerModel(ledgerType: "VAT", amount: 0),
                         LedgerModel(ledgerType: "Round Off", amount: 0),
                         LedgerModel(ledgerType: "Round Off Add", amount: 0),
                         LedgerModel(ledgerType: "Round Off Minus", amount: 0)]
        
        return arrLedger
    }
}


struct LedgerModel
{
    var ledgerType : String
    var amount: Double
}


extension Notification.Name {
    static let refreshList = Notification.Name("refreshList")
}


struct IconTitle
{
    var title : String
    var img: UIImage
}

/*

navigation

let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(withIdentifier: "Home") as? Home {
                let navigationController = UINavigationController(rootViewController: homeVC)
                navigationController.modalPresentationStyle = .fullScreen
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }



full screen view contoller

  let storyboard = UIStoryboard(name: "Main", bundle: nil)
                               if let newViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                                   newViewController.modalPresentationStyle = .fullScreen // or .overFullScreen for a transparent background
                                   present(newViewController, animated: true, completion: nil)
*/
