//
//  SettingsViewModel.swift
//  Coneqt.Live
//
//  Created by Senarios on 13/01/2022.
//

import Foundation
import Alamofire
import SafariServices
import StripeUICore


class SettingsViewModel{
    
    let controller : SettingsViewController!
    let url = URL(string: "https://api.stripe.com/v1/accounts")!
    
    init(controller : SettingsViewController){
        self.controller = controller
    }
    
    
    func createConnectedAccount(){
       print("come in create account")

        
        let email = Defaults.email ?? ""
        
       let cababilityParams = [
           "card_payments[requested]":"true",
           "transfers[requested]":"true"
       ]
       
       let parameters : Parameters = [
           "email":email,
           "type":"express",
           "business_type":"individual",
           "capabilities":cababilityParams
           
       ]
       
       let object = APIManager(headerType: .stripe, parameters: parameters, url: url)
        controller.spinner.startAnimating()
       object.getJSON { [weak self] result in
           switch result{
           case .success(let json):
               
               if let id = json["id"] as? String{
                   Defaults.connectId = id
                   self?.goForStoreConnectedId(id)
               }
               
           case .failure(let error):
               self?.controller.spinner.stopAnimating()
               print(error.localizedDescription)
           }
       }

       
 
   }
    
    func goForStoreConnectedId(_ id : String){
        print("goForStoreConnectedId")
        guard let url = Methods.shared.stringToUrl(APIEndPoints.updateConnectAccountId) else{
            controller.spinner.stopAnimating()
            return
        }
        
        let parameter = [
            "stripe_account_id":id
        ]
        
        let apiService = APIManager(headerType: .backend, parameters: parameter, url: url)
        apiService.post { [weak self] response in
            switch response{
            case .success(let json):
                print("goForStoreConnectedId json is",json)
                let success = json["success"] as? Bool ?? false
                if success{
                    self?.goOnboardingLink(id)
                }else{
                    self?.controller.spinner.stopAnimating()
                }
            case .failure(let error):
                self?.controller.spinner.stopAnimating()
                print(error.localizedDescription)
            }
        }
    }
    
    
     func goOnboardingLink(_ account : String){
        print("go for onboarding")
        let url = "https://api.stripe.com/v1/account_links"
        let header : HTTPHeaders = [

            "Authorization" : "Bearer sk_test_51Jo7TGHC0KdocDH8NFpknppOflgFxc89Ws2JNh6zrwju47t8fw0Z2cH2VlLGF9fmYBEleUUAsFjZLKsWVdTEHjUp004NvPQKKG"
        ]

        let parameters = [
            
            "account":account,
            "type":"account_onboarding",
            "return_url":"https://conneqt.senarios.co",
            "refresh_url":"https://conneqt.senarios.co",
            
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: header).responseJSON { [weak self] response in
            print("come in result go for onboarding",parameters)
            switch response.result{
          
            case .success(let json):
                print("onboarding json is",json as? [String:Any])
                guard let jsonData = json as? [String:Any] else{
                    print("Fail to get json")
                    return
                }

                if let urlString = jsonData["url"] as? String{
                    if let url = URL(string: urlString){
                       print("come in open url")
                        UIApplication.shared.openURL(url)
                        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                            self?.controller.update()
                            self?.controller.spinner.stopAnimating()
                        }
          
                    }
                }

            case .failure(let error):
                print("error come in get url request",error.localizedDescription)
                self?.controller.spinner.stopAnimating()
            }
        }
        
    }
    
  
        
    func retrieveAccount(id : String,onCompletion : @escaping (Result<ConnectedAccountModel,Error>) -> Void){
        
        guard let url  = URL(string: "https://api.stripe.com/v1/accounts/"+id) else{
            print("return from url")
            return
        }
        print("url is rerieve account",url)
        
        let call = APIManager(headerType: .stripe, url: url)
        call.getModel(model: ConnectedAccountModel.self) { response in
            
            switch response{
                
            case .success(let account):
                print("come in retrieve account response ")
                print("account is",account)
                onCompletion(.success(account))
            case .failure(let error):
                print("come in retrieve account failure ")
                print(error.localizedDescription)
                onCompletion(.failure(error))
            }
        }
        
    }
    
    
    
    
    func goToStripeDashboard(_ id : String){
        
        guard let url  = URL(string: "https://api.stripe.com/v1/accounts/"+id+"/login") else{
            print("return from url")
            return
        }
        
        let call = APIManager(headerType: .stripe, url: url,method: .post)
        call.getJSON { response in
            switch response{
            case .success(let json):
                print("json is",json)
                guard
                    let urlString = json["url"] as? String,
                    let url = URL(string: urlString) else{
                        print("fail to get the login url")
                        return
                    }
                print("come to open safari view controller")
                let sfariController = SFSafariViewController(url: url)
                self.controller.present(sfariController, animated: true)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        
    }

    
}

