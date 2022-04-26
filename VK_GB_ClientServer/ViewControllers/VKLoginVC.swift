//
//  VKLoginVC.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 16.02.2022.
//

import UIKit
import WebKit

final class VKLoginVC: UIViewController {
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    @IBAction func unwindToVKLogin(_ segue: UIStoryboardSegue) {
        Singleton.instance.token = ""
        Singleton.instance.userID = 0
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach {
                if $0.displayName.contains("vk") {
                    dataStore.removeData(
                        ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                        for: [$0]) { [weak self] in
                            guard
                                let self = self,
                                let url = self.urlComponents.url
                            else { return }
                            self.webView.load(URLRequest(url: url))
                        }
                }
            }
        }
    }
    
    private var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(
                name: "client_id",
                value: "8082049"),
            URLQueryItem(
                name: "display",
                value: "mobile"),
            URLQueryItem(
                name: "redirect_uri",
                value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(
                name: "scope",
                value: "336918"),
            URLQueryItem(
                name: "response_type",
                value: "token"),
            URLQueryItem(
                name: "v",
                value: "5.131"),
        ]
        return components
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        guard let url = urlComponents.url else { return }
        webView.load(URLRequest(url: url))
    }
}

extension VKLoginVC: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
            guard
                let url = navigationResponse.response.url,
                url.path == "/blank.html",
                let fragment = url.fragment
            else { return decisionHandler(.allow) }
            
            let parameters = fragment
                .components(separatedBy: "&")
                .map { $0.components(separatedBy: "=") }
                .reduce([String: String]()) { partialResult, parameters in
                    var dict = partialResult
                    let key = parameters[0]
                    let value = parameters[1]
                    dict[key] = value
                    return dict
                }
            
            guard
                let token = parameters["access_token"],
                let userIDString = parameters["user_id"],
                let userID = Int(userIDString)
            else { return decisionHandler(.allow) }
            
            Singleton.instance.token = token
            Singleton.instance.userID = userID
            
            let vc = storyboard?.instantiateViewController(
                withIdentifier: "main") as? UITabBarController
            vc?.modalPresentationStyle = .fullScreen
            self.present(
                vc ?? UIViewController(),
                animated: true,
                completion: nil)
            
            decisionHandler(.cancel)
    }
}

