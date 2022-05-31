//
//  Fonts.swift
//  Coneqt.Live
//
//  Created by Senarios on 13/01/2022.
//

import Foundation
import  UIKit

struct Fonts{
    
   static func get(type : FontType,size : CGFloat) -> UIFont{
        
        return UIFont(name: type.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}


enum FontType : String{
    
    case Montserrat_Regular = "Montserrat-Regular"
    case Montserrat_Medium = "Montserrat-Medium"
    case Montserrat_Bold = "Montserrat-Bold"
    case Montserrat_Semibold = "Montserrat-SemiBold"
}
