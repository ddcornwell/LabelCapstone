//
//  LabelDetailViewController.swift
//  Label
//
//  Created by DANIEL CORNWELL on 5/12/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit

class LabelDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var label: Label?
    
    @IBOutlet weak var labelImageHeaderView: LableImageHeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = label?.labelDetail
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LabelController.share.labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailText", for: indexPath) as? LabelDetailTextTableViewCell else { return UITableViewCell() }
        
        let label =  LabelController.share.labels[indexPath.row]
        
        cell.label = label
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImagesPageViewController"{
            if let imagePageVC = segue.destination as? LabelImagesPageViewController{
                imagePageVC.imageArray = label?.photos
               
            }
            if segue.identifier == "toWeb" {
                guard let web = segue.destination as? WebViewController else {return}
                web.loadViewIfNeeded()
                web.label = label
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
    @IBAction func shareButon(_ sender: Any) {
        guard let webtext = label?.labelWeb else {return}
        let activityVC = UIActivityViewController(activityItems: [webtext], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
}

