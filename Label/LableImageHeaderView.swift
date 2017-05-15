//
//  LableImageHeader.swift
//  Label
//
//  Created by DANIEL CORNWELL on 5/14/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit



class LableImageHeaderView: UIView {
 
        @IBOutlet weak var pageControl: UIPageControl!
    }
    
    extension LableImageHeaderView : LabelImagesPageViewControllerDelegate
    {
        func setupPageController(numberOfPages: Int)
        {
            pageControl.numberOfPages = numberOfPages
        }
        
        func turnPageController(to index: Int)
        {
            pageControl.currentPage = index
        }
    }

