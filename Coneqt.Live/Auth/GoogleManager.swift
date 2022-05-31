//
//  GoogleManager.swift
//  Coneqt.Live
//
//  Created by Senarios on 03/03/2022.
//

import Foundation
import Firebase
import GoogleSignIn
import SwiftUI
import StripeUICore


class GoogleManager{
    
    static let shared = GoogleManager()
    
    func getProfile(vc : BaseViewController,onCompletion : @escaping (Result<GIDGoogleUser,Error>) -> Void){
        
        
        print("come in did tap google signin")
         guard let clientID = FirebaseApp.app()?.options.clientID else {
             print("return run")
             return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: vc) { [unowned self] user, error in

          if let error = error {
            // ...
              onCompletion(.failure(error))
            return
          }

            guard let user = user else{
                onCompletion(.failure(error!))
                return
            }
            
//          guard
//            let authentication = user.authentication,
//            let idToken = authentication.idToken
//          else {
//              print("return run")
//            return
//          }
            onCompletion(.success(user))
            
      
//          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                         accessToken: authentication.accessToken)
//
//            Auth.auth().signIn(with: credential) { result, error in
//                if error != nil{
//                    print("come in error google firebase auth")
//                    return
//                }
//                print("auth result is ",result)
//            }

          // ...
        }
        

    }
}
