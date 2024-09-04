//
//  GridVC.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 19/06/24.
//

import UIKit

class DashboardVC: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblUserName: UILabel!
    
    var arrOptions = [IconTitle]()
    
    var appConstants = AppConstants.shared
    var tappedIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "DashboardItemCell", bundle: nil), forCellWithReuseIdentifier: "DashboardItemCell")
        arrOptions = appConstants.getDashboardOptions()
        
        let layout = UICollectionViewFlowLayout()
        let itemSize = (view.frame.width / 2) - 4
        layout.itemSize = CGSize(width: itemSize, height: 120)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        collectionView.collectionViewLayout = layout
        
        collectionView.reloadData()
        
        if let userModel = appConstants.loadLoginResponseFromUserDefaults()
        {
            lblUserName.text = "Hi \(userModel.data.username)"
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionAddNewStudent(_ sender: Any) {
        performSegue(withIdentifier: "toAddStudent", sender: nil)
    }
    
    @IBAction func actionLogout(_ sender: Any) {
        appConstants.clearUserDefaults {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(withIdentifier: "Home") as? Home {
                let navigationController = UINavigationController(rootViewController: homeVC)
                navigationController.modalPresentationStyle = .fullScreen
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      /* if segue.identifier == "openNext"
        {
            if let vc = segue.destination as? CustomerAddingInCartVC{
                vc.titleString = arrStudents[tappedIndex].pName
            }
        }
        else if segue.identifier == "toAddStudent"
        {
            if let vc = segue.destination as? AddStudentVC{
               // Step 1 //  assign Another class's vc
                vc.newStudentModel =  { studentModel in //Step 4
                    self.arrStudents.append(studentModel)
                    self.collectionView.reloadData()
                    
                }
            }
        }
        */
    }
}

extension DashboardVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOptions.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 180, height: 180
//        )
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedIndex = indexPath.row
        if indexPath.row == 0
        {
            performSegue(withIdentifier: "toAddItem", sender: nil)
        } else if indexPath.row == 1
        {
            performSegue(withIdentifier: "toList", sender: nil)
        }
        else if indexPath.row == 2
        {
            performSegue(withIdentifier: "toBilling", sender: nil)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardItemCell", for: indexPath) as? DashboardItemCell
        cell?.lblTitle.text = arrOptions[indexPath.row].title
        cell?.imgLogo.image = arrOptions[indexPath.row].img
        return cell ?? UICollectionViewCell()
        
    }
    
    
}
