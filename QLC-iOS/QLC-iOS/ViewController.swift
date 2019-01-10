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
    var progressView: UIProgressView = UIProgressView()
    
    let kankoreUrl = URL(string: "http://www.dmm.com/netgame/social/-/gadgets/=/app_id=854854/")
//    let kankoreUrl = URL(string: "https://www.google.co.jp")
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
        
        // プログレスバーを作成
        self.progressView = UIProgressView(frame: CGRect(x: 0.0, y:0.0 , width: webView.frame.size.width, height: 3.0))
        self.progressView.progressViewStyle = .bar
        view.addSubview(self.progressView)
        
        // プログレスバーの動作
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
        // URLロード
        let urlRequest = URLRequest(url: (kankoreUrl)!)
        self.webView.load(urlRequest)
        
        print("load start")
        
    }
    
    // デストラクタ
    deinit {
        // KVO監視を解除
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        self.webView.removeObserver(self, forKeyPath: "loading", context: nil)
    }
    
    // progress barの操作
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            // alphaを1にする(表示)
            self.progressView.alpha = 1.0
            // estimatedProgressが変更されたときにプログレスバーの値を変更
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            
            // estimatedProgressが1.0になったらアニメーションを使って非表示にしアニメーション完了時0.0をセットする
            if (self.webView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3,
                               delay: 0.3,
                               options: [.curveEaseOut],
                               animations: { [weak self] in
                                self?.progressView.alpha = 0.0
                    }, completion: {
                        (finished : Bool) in
                        self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    // ロード終了後にkcScriptを実行
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
//        print("load finished")
//        print(webView.url!)
        if(webView.url == kankoreUrl){
            webView.scrollView.isScrollEnabled = false
            webView.evaluateJavaScript(kcScript, completionHandler: nil)
        }
    }
    
    // ロード開始後5秒後にkcScriptを実行
    func webView(_ webView: WKWebView,
                 didCommit navigation: WKNavigation!) {
//        print("load started")
//        print(webView.url!)
        if(webView.url == kankoreUrl){
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                webView.evaluateJavaScript(self.kcScript, completionHandler: nil)
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let httpURLResponse = navigationResponse.response as? HTTPURLResponse else {
            return
        }  //navigationResponse.responseをHTTPURLResponseにキャスト。
//        let headers = httpURLResponse.allHeaderFields  //ヘッダー情報を`headers`に格納
//        if(httpURLResponse.url!.absoluteString.contains("kcsapi")){
        print(httpURLResponse.url!)
//        }
        
        decisionHandler(WKNavigationResponsePolicy.allow);
    }
}
