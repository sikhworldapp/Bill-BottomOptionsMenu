//
//  UpdateServicesViewModel.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 16/08/24.
//

import Foundation

class UpdateServicesViewModel
{
    func getNameResponse(name: String, id: String, completion: @escaping (GetSingleReponseByName?, String?) -> ()) {
        
        
        NetworkManagerService.shared.getProductJson(name: name, id: id) { [self] result in
            switch result {
            case .success(let response):
             
                if response.status == "true" {
                    print("Success: \(response.message)")
                    print("getting response: \(response.data as Any)")
                    
                   if let modelFromBackend: ProductWithImage = response.data
                   {
                       
                       completion(response, nil)//response getting real...
                   }
                }
                else
                {
                    completion(nil, response.message) //getting false so printing msg ..what backend shoswing
                }
                
            case .failure(let error):
                print("Failed to add product: \(error)")
                completion(nil, error.localizedDescription)
                // Handle error, show an alert, etc.
            }
            
            
        }
     }
}
