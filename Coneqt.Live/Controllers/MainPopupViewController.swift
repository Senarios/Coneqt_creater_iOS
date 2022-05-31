//
//  MainPopupViewController.swift
//  Coneqt.Live
//
//  Created by Senarios on 18/01/2022.
//

import UIKit
import FBSDKShareKit
import Social
import Alamofire



protocol DelegateDidLinkCopied{
    
    func didLinkCopy(_ value : Bool)
}


class MainPopupViewController: UIViewController {

    
    @IBOutlet weak var imgClose : UIImageView!
    
    @IBOutlet weak var lblEventCreate : UILabel!
    @IBOutlet weak var lblShareUrl : UILabel!
    @IBOutlet weak var vTwitter : UIView!
    @IBOutlet weak var vLinkden : UIView!
    @IBOutlet weak var vFacebook : UIView!
    
    @IBOutlet weak var imgTwitter : UIImageView!
    @IBOutlet weak var imgLinkden : UIImageView!
    @IBOutlet weak var imgFacebook : UIImageView!
    
    @IBOutlet weak var lblpromoteUrl : UILabel!
    @IBOutlet weak var lblUrl : UILabel!
    @IBOutlet weak var btnCopyLink : UIButton!

    var onCompletion : ((Bool) ->())?
    var link : String!
    var openLink : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Link is",link)
        imgClose.image = SVGKImage(named: "multiply").uiImage
        imgClose.isUserInteractionEnabled = true
        imgClose.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPopupDismiss)))

        
        vTwitter.layer.cornerRadius = vTwitter.frame.height/2
        vFacebook.layer.cornerRadius = vTwitter.frame.height/2
        vLinkden.layer.cornerRadius = vTwitter.frame.height/2
        
        imgLinkden.image = SVGKImage(named: "linkden_logo").uiImage
        imgFacebook.image = SVGKImage(named: "facebook_logo").uiImage
        imgTwitter.image = SVGKImage(named: "twitter_logo").uiImage
        lblUrl.text = link
        lblUrl.isUserInteractionEnabled = true
        lblUrl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOpenLink)))
      
    }
    
    @objc private func didTapPopupDismiss(){
        self.dismiss(animated: true) {
            self.onCompletion?(true)
        }
    }
    
    @objc private func didTapOpenLink(){
        if let url = URL(string: self.openLink), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    @IBAction func didTapFacebook(_ sender: UIButton) {
        print("click on facebook")
        //fb675186766859563
        
//        let url = URL(string: "fb://profile/fb675186766859563")!
//                let application = UIApplication.shared
//
//        if application.canOpenURL(url) {
//                   application.open(url)
//               } else {
//                   // If Facebook App is not installed, open Safari with Facebook Link
//                   print("Not installed")
//               }
        
        openApp(appName1: "fb", message: "not installed")
        
//        if let url = URL(string: self.openLink){
//
//                let object = ShareModel(eventUrl: url)
//                SocialMediaSharingManager.shareOnFacebook(object: object, from: self)
//                    //shareOnTwitter(object: object, from: self)
//
//                }
        
//        print("link is",self.link,"&",self.openLink)
//
//        guard let url = URL(string: self.openLink) else {
//            // handle and return
//            print("come in return")
//            return
//        }
//
//        print("url is",url)
//        let content = ShareLinkContent()
//        content.contentURL = url
//
//        let dialog = ShareDialog(
//            fromViewController: self,
//            content: content,
//            delegate: self
//        )
//        dialog.show()
        
    
    }
    
    @IBAction func didTapTwitter(_ sender: UIButton) {
        
        openApp(appName1: "twitter", message: "Twitter is not installed in your device")
    }
    
    @IBAction func didTapLinkden(_ sender: Any) {
        
        
        print("link is",self.openLink)
        
           let vc = LinkdinViewController()
            vc.completion = { token in

                print("token is",token)
                print("token is",UserDefaults.standard.string(forKey: "accessToken"))


                self.getUserProfile(token: token)
            }

            self.present(vc, animated: true)
        

    }
    
    
    //MARK: Check if app installed or not
    
    
    func openApp(appName1:String, message: String) {
        let appName = appName1
        let appScheme = "\(appName)://"
        let appUrl = URL(string: appScheme)

        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            
            if let url = URL(string: "fdsfsd"){
                    
                    let object = ShareModel(eventUrl: url)
                    SocialMediaSharingManager.shareOnFacebook(object: object, from: self)
                        //shareOnTwitter(object: object, from: self)
                        
                    }
            
//            if let url = URL(string: self.openLink){
//            let object = ShareModel(eventUrl: url)
//            SocialMediaSharingManager.shareOnTwitter(object: object, from: self)
//            }

        } else {
            Toast.show(message: message, controller: self)
        }
    }
    
    // MARK: Linkdin post sharing
    
    private func getUserProfile(token : String){
        
        
        var request = URLRequest(url: URL(string: "https://api.linkedin.com/v2/me")!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("data is",data,"error is",error)
            
            
            let status = (response as? HTTPURLResponse)?.statusCode
            
            if status == 200{
                
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject]
                    print("json is",json)
                    print("access_token value is",json?["id"] as? String)
                    let token = json?["accessToken"] as? String
                   // UserDefaults.standard.set(token, forKey: "accessToken")
                    let tokens = UserDefaults.standard.string(forKey: "accessToken")
                    
                    //self.shareLinkedinPost(token: tokens ?? "")
                    self.shareOnLinkeDin(token: tokens ?? "")
                    
              
                    
                }catch{
                    print("come in error catch")
                }

                
            }else{
                print("come in status code else")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject]
                    print("json is",json)
                    print("access_token value is",json?["access_token"] as? String)
                    let token = json?["accessToken"] as? String
                    UserDefaults.standard.set(token, forKey: "accessToken")
                }catch{
                    print("come in error catch")
                }
            }
        }.resume()
    }
    
    func shareOnLinkeDin(token: String){
      
        let url = "https://api.linkedin.com/v2/ugcPosts"
        let headers: HTTPHeaders = ["Content-Type":"application/json","Authorization":"Bearer \(token)"]

        let dic1 = [
            "com.linkedin.ugc.ShareContent":[
                
                "shareCommentary":[
                    "text":"\(openLink ?? "nothing")"
                ],
                "shareMediaCategory":"NONE"
            ]
        ]
        
        let dic2 = [
            
            "com.linkedin.ugc.MemberNetworkVisibility":"PUBLIC"
        ]
        
        let param = [
            "author": "urn:li:person:mnUNUMwItR",
            "lifecycleState": "PUBLISHED",
            "specificContent": dic1,
            "visibility": dic2
        ] as [String : Any]
        print(param)
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            switch response.result{
          
            case .success(let json):
                print("onboarding json is",json as? [String:Any])
                guard let jsonData = json as? [String:Any] else{
                    print("Fail to get json")
                    return
                }

                if let urlString = jsonData["id"] as? String{
                    if let url = URL(string: urlString){
                       print("come in open url")
                        UIApplication.shared.openURL(url)
                        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                            self.dismiss(animated: true, completion: nil)
                          
                        }
                    }
                }

            case .failure(let error):
                print("error come in get url request",error.localizedDescription)
                
            }
        }
        
    }
    
    
    @IBAction func CopyLink_Clicked(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = openLink
        
        Toast.show(message: "Link Copied!", controller: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.dismiss(animated: true) {
                self.onCompletion?(true)
            }
        }
    }
    

}


extension MainPopupViewController : SharingDelegate{
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("##come in result",results)
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("##come in failure",error.localizedDescription)
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        print("##come in cancle")
    }
    
}


struct ShareModel : SocialMediaShareable{
    
    let eventUrl : URL
    
    func image() -> UIImage? {
        return nil
    }
    
    func url() -> URL? {
        return eventUrl
    }
    
    func text() -> String? {
        return ""
    }
    
    
}
