//
//  LabelShopTableViewCell.swift
//  Label
//
//  Created by DANIEL CORNWELL on 3/26/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit

class LabelShopTableViewCell: UITableViewCell {

    @IBOutlet weak var labelImage: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    
    var label: Label? {
        didSet{
            updateViews()
            
        }
        
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            
            guard let label = self.label else {return}
            self.labelImage.image = label.photo
            self.labelText.text = label.labelTitle
            
        }
    }

}
