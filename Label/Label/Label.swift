//
//  Best.swift
//  Label
//
//  Created by DANIEL CORNWELL on 3/15/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit
import CloudKit

class Label: CloudKitSyncable {
    
    static let labelImagesKey = "labelImages"
    static let imageKey = "labelImageData"
    static let titleKey = "labelTitle"
    static let detailKey = "labelDetail"
    static let likeKey = "labelLike"
    static let categoryKey = "labelCategory"
    static let webKey = "labelWeb"
    static let recordType = "Label"
    static let shortKey = "labelShort"
    
    let labelImages: [CKAsset]
    let labelImage: Data?
    let labelTitle: String
    let labelDetail: String
    let labelLike: Double
    let labelCategory: String
    let labelWeb: String
    let labelShort: String
    
    var photo: UIImage? {
        guard let labelImage = self.labelImage else { return nil }
        return UIImage(data: labelImage)
    }
    
    var photos: [UIImage] {
        
        let labelImages = self.labelImages.flatMap( { try? Data(contentsOf: $0.fileURL) } )
        let images = labelImages.flatMap( { UIImage(data: $0) } )
        return images
    }
    
    // init for model
    init(labelImages: [CKAsset] = [], labelImage: Data?, labelTitle: String, labelDetail: String, labelLike: Double, labelCategory: String, labelWeb: String, labelShort: String ) {
        
        self.labelImages = labelImages
        self.labelImage = labelImage
        self.labelTitle = labelTitle
        self.labelDetail = labelDetail
        self.labelLike = labelLike
        self.labelCategory = labelCategory
        self.labelWeb = labelWeb
        self.labelShort = labelShort
    }
    
    //cloud kit
    var recordType: String{
        return Label.recordType
    }
    
    var cloudKitRecordID: CKRecordID?
    
    convenience required init?(record: CKRecord) {
        guard let labelAsset = record[Label.imageKey] as? CKAsset,
            let labelTitle = record[Label.titleKey] as? String,
            let labelDetail = record[Label.detailKey] as? String,
            let labelLike = record[Label.likeKey] as? Double,
            let labelCategory = record[Label.categoryKey] as? String,
            let labelWeb = record[Label.webKey] as? String,
            let labelShort = record[Label.shortKey] as? String else {return nil}
        let labelImage = try? Data(contentsOf: labelAsset.fileURL)
        let labelImagesData = record[Label.labelImagesKey] as? [CKAsset] ?? []
        self.init(labelImages: labelImagesData, labelImage: labelImage, labelTitle: labelTitle, labelDetail: labelDetail, labelLike: labelLike, labelCategory: labelCategory, labelWeb: labelWeb, labelShort: labelShort)
        cloudKitRecordID = record.recordID
    }
    
    fileprivate var temoraryPhotoURL: URL {
        let tempDirectory = NSTemporaryDirectory()
        let temDirectoryURL = URL(fileURLWithPath: tempDirectory)
        let fileURL = temDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        try? labelImage?.write(to: fileURL, options: .atomic)
        return fileURL
    }
}
