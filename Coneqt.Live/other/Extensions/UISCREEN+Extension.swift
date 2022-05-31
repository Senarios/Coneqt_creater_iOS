//
//  UISCREEN+Extension.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 29/11/2021.
//
import UIKit

extension UIScreen{
    
   static var width : CGFloat{
       return main.bounds.width
    }
    
    static var height : CGFloat{
        return main.bounds.height
    }
    
    static var top : CGFloat{
        return main.bounds.origin.x
    }
    
    static var bottom : CGFloat{
        return main.bounds.origin.y
    }
    
    
    
}
