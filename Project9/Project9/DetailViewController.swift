//
//  DetailViewController.swift
//  Project9
//
//  Created by Allan Amaral on 10/08/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let petition = detailItem else { return }
        
        let html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <style>
                    html {
                        font-size: 150%;
                        font-family: system-ui, -apple-system, sans-serif;
                        padding-inline: 1rem;
                    }
                    h1 {
                        font-size: 1.25rem;
                    }
                </style>
            </head>
        
            <body>
                <h1>\(petition.title)</h1>
                \(petition.body)
            </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }

}
