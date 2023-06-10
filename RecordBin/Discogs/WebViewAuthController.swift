//
//  WebViewAuthController.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/4/23.
//

import OAuthSwift
import AppKit
import WebKit

class WebViewAuthController: OAuthWebViewController {
  var targetURL: URL?
  let webView = WKWebView()
  
  override func loadView() {
  //  present = .asSheet
    view = NSView()
    view.frame = CGRect(x: 0, y: 0, width: 640, height: 480)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   // useTopViewControlerInsteadOfNavigation = true
    
    webView.frame = view.bounds
    webView.navigationDelegate = self
    webView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(webView)
    
    let constraints = [
//      webView.heightAnchor.constraint(equalToConstant: view.heightAnchor)
//      webView.widthAnchor.constraint(equalToConstant: view.widthAnchor)
      webView.topAnchor.constraint(equalTo: view.topAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  override func handle(_ url: URL) {
    targetURL = url
      super.handle(url)
      self.loadAddressURL()
  }
  
  func loadAddressURL() {
          guard let url = targetURL else {
              return
          }
          let req = URLRequest(url: url)
          DispatchQueue.main.async {
              self.webView.load(req)
          }
      }
}

extension WebViewAuthController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      
      // here we handle internally the callback url and call method that call handleOpenURL (not app scheme used)
      if let url = navigationAction.request.url , url.scheme == "record-bin" {
          // handle our state..
        //  AppDelegate.sharedInstance.applicationHandle(url: url)
          OAuthSwift.handle(url: url)
          decisionHandler(.cancel)
          
          self.dismissWebViewController()
          return
      }
      
      decisionHandler(.allow)
  }
}
