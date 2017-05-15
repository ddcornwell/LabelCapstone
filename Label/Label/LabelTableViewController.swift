//
//  LabelTableViewController.swift
//  Label
//
//  Created by DANIEL CORNWELL on 3/13/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit


class LabelTableViewController: UITableViewController, LabelControllerDelegate {
    
       
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
    
    @IBAction func refreshControlActivated(_ sender: Any) {
        LabelController.share.fetchMessagesFromCloudKit()
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LabelController.share.labels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as? LabelTableViewCell else { return UITableViewCell() }
        
        let label =  LabelController.share.labels[indexPath.row]
        
        cell.label = label
        if cell.isHidden {
            cell.isHidden = false
        }
        return cell
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            guard let DV = segue.destination as? LabelDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow  else { return }
            DV.loadViewIfNeeded()
            let label = LabelController.share.labels[indexPath.row]
            DV.label = label
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }

}
