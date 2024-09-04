//
//  BaseViewController.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 01/07/24.
//

import UIKit
import Toast
import SVProgressHUD

class BaseViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        displayCurrentViewControllerName()
    }
    
    func displayCurrentViewControllerName() {
           if let className = NSStringFromClass(type(of: self)).components(separatedBy: ".").last {
               print("Current View Controller: \(className)")
           }
       }
    
    func showProgress(_ msg: String? = "")
    {
        if let msgExists = msg, msgExists.count > 0
        {
            SVProgressHUD.show(withStatus: msg)
        }
        else
        {
            SVProgressHUD.show()
        }
        
    }
    
    func hideProgress()
    {
        SVProgressHUD.dismiss()
    }
    
    func finish()
    {
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    func printOut(msg: String)
    {
        print(msg)
    }
    
    func showToast(_ titles: String, msg: String, _ img: UIImage? =  UIImage(named: "profile"), position: ToastPosition?)
    {
        self.view.makeToast(msg, duration: 2.0, position: position ?? ToastPosition.bottom,  title: titles, image: img ) { didTap in
            if didTap {
                print("completion from tap")
            } else {
                print("completion without tap")
            }
        }
    }
    
    func showToastMsg(_ titles: String, msg: String, position: ToastPosition?)
    {
        self.view.makeToast(msg, duration: 2.0, position: position ?? ToastPosition.bottom,  title: titles ) { didTap in
            if didTap {
                print("completion from tap")
            } else {
                print("completion without tap")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        // Step 2: Create an instance of UIAlertController
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        // Step 3: Add actions (buttons)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Code to execute when the OK button is pressed
            print("OK button tapped")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Code to execute when the OK button is pressed
            print("cancel button tapped")
        }
        
        let proceedAction = UIAlertAction(title: "Proceed", style: .destructive) { _ in
            // Code to execute when the OK button is pressed
            print("proceedAction button tapped")
        }
        
        // Add the action to the alert controller
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.addAction(proceedAction)
        
        // Step 4: Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertMsg(title: String, message: String) {
        // Step 2: Create an instance of UIAlertController
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Step 3: Add actions (buttons)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Code to execute when the OK button is pressed
            print("OK button tapped")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Code to execute when the OK button is pressed
            print("cancel button tapped")
        }
        
      
        
        // Add the action to the alert controller
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Step 4: Present the alert
        self.present(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class BaseVC: UIViewController
{
    
}
