//
//  BottomSheetValueEditingVC.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 26/07/24.
//

import UIKit

class BottomSheetValueEditingVC: UIViewController {

    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var lblHeading: UILabel!
    
    var headingString = ""
    
    
    var callBack: ((String, Double) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblHeading.text = headingString
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionDone(_ sender: Any) {
    
        let doubleValue = Double(txtValue.text ?? "0.0") ?? 0.0
        
        // Check if the callback is set and call it
        callBack?(headingString, doubleValue)
        
        // Pop the view controller to return to the previous screen
        navigationController?.popViewController(animated: true)
    }
    
}
