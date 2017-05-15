//
//  CloudManager.swift
//  Label
//
//  Created by DANIEL CORNWELL on 3/15/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import Foundation
import CloudKit


class CloudKitManager {
    
    static let share = CloudKitManager()
    
    let database = CKContainer.default().publicCloudDatabase
    
    func fetchRecords(ofType type: String,
                      sortDescriptors: [NSSortDescriptor]? = nil,
                      completion: @escaping ([CKRecord]?, Error?) -> Void) {
        
        let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
        query.sortDescriptors = sortDescriptors
        
        database.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    
    func save(_ record: CKRecord, completion: @escaping ((Error?) -> Void) = { _ in }) {
        
        database.save(record, completionHandler: { (record, error) in
            completion(error)
        })
    }
    
    func subscribeToCreationOfRecords(ofType type: String, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let subscription = CKQuerySubscription(recordType: type, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "There's a new message on the bulletin board."
        subscription.notificationInfo = notificationInfo
        database.save(subscription, completionHandler: { (subscription, error) in
            if let error = error {
                NSLog("Error saving subscription: \(error)")
            }
            completion(error)
        })
    }
}
