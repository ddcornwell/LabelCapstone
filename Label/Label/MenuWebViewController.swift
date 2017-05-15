//
//  MenuWebViewController.swift
//  Label
//
//  Created by DANIEL CORNWELL on 3/29/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit


class MenuWebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var active: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        active.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        active.stopAnimating()
    }
    
    var label: Label? {
        didSet {
            updateView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = label?.labelTitle
        
    }
    
    func updateView() {
        guard let myurlstring = label?.labelWeb else {return}
        guard let myurl = URL(string: myurlstring) else {return}
        webView.loadRequest(NSURLRequest(url: myurl) as URLRequest)
        guard let label = label else {return}
        self.title = "\(label.labelTitle)"
        
        
    }
}
