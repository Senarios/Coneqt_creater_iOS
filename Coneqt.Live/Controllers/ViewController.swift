//
//  ViewController.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 25/11/2021.
//

import UIKit
import FirebaseDatabase
import Alamofire


struct User1 : Decodable{
    
    let id : Int
    let name : String
    let username : String
}

class ViewController: UIViewController {
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let path = FirebaseManager.shared.ref.child("streams/123445/messages").childByAutoId()
        //        let value = ["message":"i am zain ahmed"]
        //        FirebaseManager.shared.generalAddFunction(path: path, value: value)
        
        
        
        //        let query = FirebaseManager.shared.ref.child("streams/67678689/chat").queryLimited(toLast: 1)
        //        let path = FirebaseManager.shared.ref.child("streams/67678689/chat")
        //        FirebaseManager.shared.observe(query: query, path: nil, event: .childAdded){ result in
        //
        //            switch result{
        //            case .success(let data):
        //                print(data.value)
        //            case .failure(let error):
        //                print(error.localizedDescription)
        //            }
        //
        //        }
        
        //        let vc = UIStoryboard(name: "Stream", bundle: nil).instantiateViewController(withIdentifier: "\(StreamUsersViewController.self)") as! StreamUsersViewController
        //        let nav = UINavigationController(rootViewController: vc)
        //        nav.navigationBar.barTintColor = .systemGray
        //        present(nav, animated: true)
        
//        let path = Bundle.main.path(forResource: "test", ofType: "json")!
//        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//        let json = try! JSONSerialization.jsonObject(with: data, options: [])
//        let jsonData = json as! [String:Any]
//        print("require data is",jsonData["id"])
        
//        let url = URL(string: "https://www.hackingwithswift.com")!
//        webView.load(URLRequest(url: url))
//        webView.allowsBackForwardNavigationGestures = true
        
      
        
    }
    
    
    
    @IBAction func didTapModule(_ sender: UIButton) {
        
        if !NetworkMonitor.shared.isConnected{
            print("please connect to network first")
            return
        }
        
//        var viewController : UIViewController!
//        if sender.tag == 0{
//            viewController = ViewControllers.getViewController(viewController: MainStreamViewController(), storyboardName: "Stream")
//        }else if sender.tag == 1{
//            viewController = ViewControllers.getViewController(viewController: MainStreamViewController(), storyboardName: "Stream")
//            //             viewController = UIStoryboard(name: "Stream", bundle: nil).instantiateViewController(withIdentifier: "MainStreamViewController") as! MainStreamViewController
//        }else{
//            
//            viewController = ViewControllers.getViewController(viewController: LoginViewController(), storyboardName: "Auth")
//        }
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


class ViewControllers{
    
    var items : String = ""
    
    static func get<T:UIViewController>(_ viewController:T, from storyboardName:String) -> T {
        guard let nextViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: String(describing: T.self)) as? T else { fatalError() }
        return nextViewController
    }
    
}
