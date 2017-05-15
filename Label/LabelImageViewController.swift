//
//  LabelImageViewController.swift
//  Label
//
//  Created by DANIEL CORNWELL on 5/11/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit

class LabelImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
        self.imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.imageView.image = image
    }

}
