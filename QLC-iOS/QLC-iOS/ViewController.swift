//
//  ViewController.swift
//  QLC-iOS
//
//  Created by saitoy55 on 2018/08/18.
//  Copyright © 2018年 saitoy55. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Hello, world")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class WebViewController: UIViewController, WKNavigationDelegate {
    let webView: WKWebView = WKWebView()
    let kankoreUrl = URL(string: "http://www.dmm.com/netgame/social/-/gadgets/=/app_id=854854/")
    let kcScript: String = "document.getElementsByClassName(\"dmm-ntgnavi\")[0].setAttribute(\"style\",\"display: none;\");document.getElementById(\"main-ntg\").setAttribute(\"style\",\"text-align: start;\");document.getElementById(\"main-ntg\").setAttribute(\"style\",\"margin-top:-16px;\");document.getElementById(\"game_frame\").setAttribute(\"style\",\"transform:scale(0.863);margin-top:-80px;\")"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 多分webviewを作成している
        webView.frame = view.bounds
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
//        webView.scrollView.isScrollEnabled = false

        // サブビューとして追加
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)

        // 制約を追加
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        
//        let url = URL(string: "https://www.google.co.jp")
        let urlRequest = URLRequest(url: (kankoreUrl)!)
        self.webView.load(urlRequest)
        
        print("load start")
        
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        print("load finished")
        print(webView.url!)
        if(webView.url == kankoreUrl){
            webView.scrollView.isScrollEnabled = false
            webView.evaluateJavaScript(kcScript, completionHandler: nil)
        }
    }

    func webView(_ webView: WKWebView,
                 didCommit navigation: WKNavigation!) {
        print("load started")
        print(webView.url!)
        if(webView.url == kankoreUrl){
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                webView.evaluateJavaScript(self.kcScript, completionHandler: nil)
            }
        }
    }

    
}
