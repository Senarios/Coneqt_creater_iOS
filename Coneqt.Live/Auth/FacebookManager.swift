//
//  FacebookManager.swift
//  Coneqt.Live
//
//  Created by Senarios on 03/03/2022.
//

import Foundation
import FBSDKLoginKit
import StripeUICore

class FacebookManager{ 
    
    static let shared = FacebookManager()
    
    func getProfile(vc : BaseViewController,onCompletion :  @escaping(Result<[String:Any],Error>) -> Void){
        
    /*    let fbLoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
                    
                    // 4
                    // Check for error
                    guard error == nil else {
                        // Error occurred
                        print(error!.localizedDescription)
                        return
                    }
                    
                    // 5
                    // Check for cancel
                    guard let result = result, !result.isCancelled else {
                        print("User cancelled login")
                        return
                    }
                  
                    // Successfully logged in
                    // 6
                    self?.updateButton(isLoggedIn: true)
                    
                    // 7
                    Profile.loadCurrentProfile { (profile, error) in
                        self?.updateMessage(with: Profile.current?.name)
                    }
                }
        
        */
        
     /*   let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: vc) { result, error in
            let token = result?.token?.tokenString
            print("result is",result)
            print("FB token is",token)
            print("error is",error?.localizedDescription)
            if error != nil{

                print("return from facebooklogin callback error",error?.localizedDescription)
            }

            let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                       parameters: ["fields":"email,first_name,last_name,picture.type(large)"],
                                       tokenString: token, version: nil,
                                       httpMethod: .get)
            
//            let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
//                                                             parameters: ["fields":"email,first_name,last_name,picture.type(large)"],httpMethod: .get)

            facebookRequest.start { _, result, error in
               print("result is",result)
                guard let result = result as? [String:Any], error == nil else{
                    print("Failed Graph request")
                    onCompletion(.failure(error as! Error))
                    return
                }
                onCompletion(.success(result))
            }
        }*/
    }
}
