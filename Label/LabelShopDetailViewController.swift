//
//  LabelShopDetailViewController.swift
//  Label
//
//  Created by DANIEL CORNWELL on 3/27/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit

class LabelShopDetailViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var labelText: UITextView!
    @IBOutlet weak var shortButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    var label: Label? {
        didSet{
            if !isViewLoaded{
                loadView()
            }
            updateView()
        }
        
    }
    
    var imageArray = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
 
    
    func updateView() {
        guard let label = label else {return}
        
        shortButton.setTitle(label.labelShort, for: .normal)
        labelText.text = label.labelDetail
        self.title = label.labelTitle
        imageArray = label.photos
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        setupImageViews()
        configurePageControl()
        
    }
    
    
    func setupImageViews() {
        var totalWidth: CGFloat = 0
        
        for i in 0..<imageArray.count {
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            scrollView.isPagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = UIColor.white
            imageView.frame = CGRect(origin: CGPoint(x: totalWidth, y: 0),
                                     size: scrollView.bounds.size)
            imageView.contentMode = .scaleAspectFit
            
            scrollView.addSubview(imageView)
            totalWidth += imageView.bounds.size.width
        }
        
        scrollView.contentSize = CGSize(width: totalWidth,
                                        height: scrollView.bounds.size.height)
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = imageArray.count
        self.pageControl.currentPage = 0
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    
    @IBAction func shareButton(_ sender: Any) {
        guard let webtext = label?.labelWeb else {return}
        
        let activityVC = UIActivityViewController(activityItems: [webtext], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebMenu" {
            guard let web = segue.destination as? MenuWebViewController else {return}
            web.loadViewIfNeeded()
            web.label = label
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
        
    }

}
