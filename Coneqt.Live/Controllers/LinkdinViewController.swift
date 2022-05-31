//
//  LinkdinViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 4/8/22.
//

import UIKit
import WebKit

class LinkdinViewController: UIViewController,WKNavigationDelegate {

    
    
    
    var linkedInKey = "77f314blcgxzcy"
    var linkdinScreat = "l1JhGjTOFgHjg0Sz"
    var authorizationEndPoint = "https://www.linkedin.com/oauth/v2/authorization"
    var accessTokenUrl = "https://www.linkedin.com/oauth/v2/accessToken"
    
    var webView: WKWebView!
    
    var completion : ((String) -> Void)!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startAuthorization()
    }
    

    
    
    func startAuthorization() {
        
        
        // Specify the response type which should always be "code".
        let responseType = "code"
     
        // Set the redirect URL. Adding the percent escape characthers is necessary.
        let redirectURL = "https://conneqt.senarios.co"
         //   .addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
           print("redirect url is",redirectURL)
     
        // Create a random string based on the time interval (it will be in the form linkedin12345679).
        let state = "linkedin\(Int(Date().timeIntervalSince1970))"
     
        // Set preferred scope.
        let scope = "r_liteprofile%20r_emailaddress%20w_member_social"
        
        
        
        // Create the authorization URL string.
           var authorizationURL = "\(authorizationEndPoint)?"
           authorizationURL += "response_type=\(responseType)&"
           authorizationURL += "client_id=\(linkedInKey)&"
           authorizationURL += "redirect_uri=\(redirectURL)&"
           authorizationURL += "state=\(state)&"
           authorizationURL += "scope=\(scope)"
        
           print("auth url is",authorizationURL)

        
        // Create a URL request and load it in the web view.
        let request = URLRequest(url: URL(string: authorizationURL)!)

      
        
        
     //   webView.load(URLRequest(url: url))
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
 

    }
    
    
    
    
    func getAccessToken(code : String){
     
        print("get access token is",code)
        let grantType = "authorization_code"
        let authorizationCode = code
        let redirectURL = "https://conneqt.senarios.co"
        // Set the POST parameters.
         var postParams = "grant_type=\(grantType)&"
         postParams += "code=\(authorizationCode)&"
         postParams += "redirect_uri=\(redirectURL)&"
         postParams += "client_id=\(linkedInKey)&"
         postParams += "client_secret=\(linkdinScreat)"
        
        let postData = postParams.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: self.accessTokenUrl)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            print("status code is",statusCode)
            print("error",error?.localizedDescription)
            print("data is",data)
            if statusCode == 200{
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject]
                    
                    print(json)
                    
                    print("json is",json)
                    print("access_token value is",json?["access_token"] as? String)
                    let token = json?["access_token"] as? String
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    
                    DispatchQueue.main.async {
                        print("dismiss run")
                        self.completion(token!)
                        self.dismiss(animated: true)
                    }
                    
                    
                    
                }catch{
                    print("come in error catch")
                }
            }
        }.resume()
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @available(iOS 15.0, *)
    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        let url = navigationResponse.response.url
        print("url is",url)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var action: WKNavigationActionPolicy?

        defer {
            decisionHandler(action ?? .allow)
        }

        guard let url = navigationAction.request.url else { return }

        print("decide policy",url)
        
        if url.host == "conneqt.senarios.co"{
        if url.absoluteString.range(of: "code") != nil{
          
                       
            let urlParts = url.absoluteString.components(separatedBy: "?")
            let code = urlParts[1].components(separatedBy: "=")[1]
            print("code is",code)
            getAccessToken(code: code)
        }
        }
        

//        if navigationAction.navigationType == .linkActivated, url.absoluteString.hasPrefix("http://www.example.com/open-in-safari") {
//            action = .cancel                  // Stop in WebView
//            UIApplication.shared.openURL(url) // Open in Safari
//        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(String(describing: webView.url))
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("come in fail",error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(String(describing: webView.url))
    }

    
}

