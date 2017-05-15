//
//  PopoOverViewController.swift
//  Label
//
//  Created by DANIEL CORNWELL on 3/23/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit

class PopoOverViewController: UIViewController {

    
    var categoryToBeSent: String = ""
    
    
    
    @IBAction func farmsButtonTapped(_ sender: Any) {
        
        self.categoryToBeSent = "Farms"
        
        performSegue(withIdentifier: "toFilteredTVC", sender: self)
    }
    
    @IBAction func productsButtonTapped(_ sender: Any) {
        
        self.categoryToBeSent = "Products"
        
        performSegue(withIdentifier: "toFilteredTVC", sender: self)
    }
    
    @IBAction func vitaminsButtonTapped(_ sender: Any) {
        
        self.categoryToBeSent = "Vitamins"
        
        performSegue(withIdentifier: "toFilteredTVC", sender: self)
        
    }
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

        

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "toFilteredTVC" {
            let destinationVC = segue.destination as? LabelShopTableViewController
            destinationVC?.labelCategory = categoryToBeSent
            let backItem = UIBarButtonItem()
            backItem.title =  ""
            navigationItem.backBarButtonItem = backItem
            
        }
        
    }

}
