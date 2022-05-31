//
//  SocialMediaSharingManager.swift
//  Coneqt.Live
//
//  Created by Senarios on 24/03/2022.
//

import Foundation
import UIKit
import Social

public protocol SocialMediaShareable {
    
    func image() -> UIImage?
    func url() -> URL?
    func text() -> String?
    
}


public class SocialMediaSharingManager{
    
    public static func shareOnFacebook(object : SocialMediaShareable,from presentingVC : UIViewController){
        
        share(object: object, for: SLServiceTypeFacebook, from: presentingVC)
        
    }
    
    
    public static func shareOnTwitter(object : SocialMediaShareable, from presentingVC: UIViewController) {
        
       
           share(object: object, for: SLServiceTypeTwitter, from: presentingVC)
        
    }
    
    
    public static func shareOnLinkedin(object : SocialMediaShareable, from presentingVC: UIViewController) {
        
        share(object: object, for: SLServiceTypeLinkedIn, from: presentingVC)
    }
    
    
    private static func share(object: SocialMediaShareable, for serviceType: String, from presentingVC: UIViewController) {

        print(serviceType)
        
    
            if let composeVC = SLComposeViewController(forServiceType:serviceType) {
                
                composeVC.add(object.image())
                composeVC.add(object.url())
                composeVC.setInitialText(object.text())
                presentingVC.present(composeVC, animated: true, completion: nil)
            }
            
        else {
            
            Toast.show(message: "Application not avaiable in your phone", controller: presentingVC)
        }
        
        
        
    }
    
    
}
