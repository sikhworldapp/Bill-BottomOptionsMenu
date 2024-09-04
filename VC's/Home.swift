//
//  Home.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 23/08/24.
//

import UIKit

class Home: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if prefs.bool(forKey: AppConstants.shared.isLoggedIn)
        {
            performSegue(withIdentifier: "toDashboard", sender: nil)
        }
      
    }
 

}
