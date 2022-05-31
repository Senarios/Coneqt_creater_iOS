//
//  AppleLoginManager.swift
//  Coneqt.Live
//
//  Created by Azhar on 3/29/22.
//

import Foundation
import AuthenticationServices


class AppleLoginManager{
    
    
    static let shared = AppleLoginManager()
    
    func getProfile(vc : SignInViewController,onCompletion : @escaping (Result<ASAuthorizationAppleIDCredential,Error>) -> Void){
        
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = vc
        controller.presentationContextProvider = vc
        
        controller.performRequests()
        
        
        
    }
    
    
}

