//
//  LabelDetailTextTableViewCell.swift
//  Label
//
//  Created by DANIEL CORNWELL on 5/14/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit

class LabelDetailTextTableViewCell: UITableViewCell {


    @IBOutlet weak var labelText: UILabel!
    
    var label: Label? {
        didSet{
            updateViews()
        }
        
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            guard let label = self.label else {return}
            self.labelText.text = label.labelDetail
        }
    }

}
