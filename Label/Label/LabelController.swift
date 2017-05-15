//
//  LabelController.swift
//  Label
//
//  Created by DANIEL CORNWELL on 3/13/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import Foundation
import CloudKit

class LabelController {
    
    static let share = LabelController()
    
    let cloudKitManager = CloudKitManager()
    
    var delegate: LabelControllerDelegate?
    
    var labels: [Label] = [] {
        didSet {
            NSLog("Labels updated")
            DispatchQueue.main.async {
                self.delegate?.labelsWereUpdated()
            }
        }
    }
    
    var labelSort : [Label] {
        return self.labels.sorted { $0.labelLike < $1.labelLike }
    }
    
    var farmLabels: [Label] {
        return self.labelSort.filter({$0.labelCategory == "Farms"})
    }
    
    var productLabels: [Label] {
        
        return self.labelSort.filter( {$0.labelCategory == "Products" } )
    }
    
    var vitaminLabels: [Label] {
        
        return self.labelSort.filter( {$0.labelCategory == "Vitamins" } )
    }
    
    init(){
        fetchMessagesFromCloudKit()
    }
    
    func fetchMessagesFromCloudKit() {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Labels", predicate: predicate)
        
        CloudKitManager.share.database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error { print("what the hell \(error.localizedDescription)") }
            
            guard let records = records else { print("No records returned"); return }
            
            let labels = records.flatMap({ Label(record: $0) })
            
            DispatchQueue.main.async {
                self.labels = labels
            }
        }
    }
}

protocol LabelControllerDelegate {
    func labelsWereUpdated()
}
