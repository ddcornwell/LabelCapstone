//
//  webViewController.swift
//  Label
//
//  Created by DANIEL CORNWELL on 3/16/17.
//  Copyright © 2017 DANIEL CORNWELL. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var active: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = label?.labelTitle
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
    
    func updateView() {
        guard let myurlstring = label?.labelWeb else {return}
        guard let myurl = URL(string: myurlstring) else {return}
        webView.loadRequest(NSURLRequest(url: myurl) as URLRequest)
        guard let label = label else {return}
        self.title = "\(label.labelTitle)"
    }
}
