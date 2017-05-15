//
//  LabelShopTableViewController.swift
//  Label
//
//  Created by DANIEL CORNWELL on 3/26/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit
import CloudKit

class LabelShopTableViewController: UITableViewController,LabelControllerDelegate {
    
     var labelCategory = ""
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        LabelController.share.delegate = self
        LabelController.share.fetchMessagesFromCloudKit()
        
    }
    
    func labelsWereUpdated() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.labelCategory == "Farms" {
            return LabelController.share.farmLabels.count
        } else if self.labelCategory == "Products" {
            return LabelController.share.productLabels.count
        } else if self.labelCategory == "Vitamins" {
            return LabelController.share.vitaminLabels.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as? LabelShopTableViewCell else { return UITableViewCell() }
        
        if self.labelCategory == "Farms" {
            let label = LabelController.share.farmLabels[indexPath.row]
            cell.label = label
            
        } else if self.labelCategory == "Products" {
            let label =  LabelController.share.productLabels[indexPath.row]
            cell.label = label
            
        } else if self.labelCategory == "Vitamins" {
            let label =  LabelController.share.vitaminLabels[indexPath.row]
            cell.label = label
            
        } else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShop" {
            guard let DV = segue.destination as? LabelShopDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow  else { return }
            DV.loadViewIfNeeded()
            if labelCategory == "Farms" {
            let label = LabelController.share.farmLabels[indexPath.row]
                DV.label = label
            }
            if labelCategory == "Products" {
                let label = LabelController.share.productLabels[indexPath.row]
                DV.label = label
            }
            if labelCategory == "Vitamins" {
                let label = LabelController.share.vitaminLabels[indexPath.row]
                DV.label = label
            }
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }
}
