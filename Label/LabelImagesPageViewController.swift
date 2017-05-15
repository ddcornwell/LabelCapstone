//
//  LabelImagesPageViewController.swift
//  Label
//
//  Created by DANIEL CORNWELL on 5/11/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit
protocol LabelImagesPageViewControllerDelegate: class
{
    func setupPageController(numberOfPages: Int)
    func turnPageController(to index: Int)
}
class LabelImagesPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
   weak var pageViewControllerDelegate: LabelImagesPageViewControllerDelegate?
    
    var label: Label? {
        didSet{
            if !isViewLoaded{
                loadView()
            }
            updateView()
        }
        
    }
    
    var imageArray : [UIImage]? = LabelController.share.labels.first?.photos
    
    func updateView() {
        guard let label = label else {return}
              imageArray = label.photos
      
        
    }
 
    

    
    lazy var controllers: [UIViewController] = {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var controllers = [UIViewController]()
        if let images = self.imageArray {
            for image in images {
            let labelImageVC = storyboard.instantiateViewController(withIdentifier: "labelImageViewController")
                controllers.append(labelImageVC)
            }
        }

        return controllers
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.dataSource = self
        
        
        if let firstViewController = controllers.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    func turnToPage(index: Int)
    {
        let controller = controllers[index]
        var direction = UIPageViewControllerNavigationDirection.forward
        
        if let currentVC = viewControllers?.first {
            let currentIndex = controllers.index(of: currentVC)!
            if currentIndex > index {
                direction = .reverse
            }
        }
        
        self.configureDisplaying(viewController: controller)
        
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func configureDisplaying(viewController: UIViewController)
    {
        for (index, vc) in controllers.enumerated() {
            if viewController === vc {
                if let shoeImageVC = viewController as? LabelImageViewController {
                    shoeImageVC.image = self.imageArray?[index]
                    
                    self.pageViewControllerDelegate?.turnPageController(to: index)
                }
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if let index = controllers.index(of: viewController) {
            if index > 0 {
                return controllers[index-1]
            }
        }
        
        return controllers.last
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if let index = controllers.index(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            }
        }
        
        return controllers.first
    }
}
