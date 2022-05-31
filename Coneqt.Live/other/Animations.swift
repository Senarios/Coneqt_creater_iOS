//
//  Animations.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 29/11/2021.
//

import Foundation
import UIKit


class Animations{
    
    static let shared = Animations()
    
    func customPath() -> UIBezierPath{
        print("come in custom path")
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: UIScreen.width - 100, y: UIScreen.height - 60))
        
        let endPoint = CGPoint(x: 310, y: UIScreen.main.bounds.origin.x + 200)
        let randomXShift = 50 + drand48() * 100
        let c1 = CGPoint(x: 310 + randomXShift, y: 250)
        let c2 = CGPoint(x: 310 - randomXShift, y: 600)
        print("randYshift is",randomXShift)
        
    //        let c1 = CGPoint(x: 110 , y: 400)
    //        let c2 = CGPoint(x: 410 , y: 500 )
        
        path.addCurve(to: endPoint, controlPoint1: c1, controlPoint2: c2)
      //  path.addLine(to: endPoint)
        path.lineWidth = 3
       
        return path
    }





    func customPath1() -> UIBezierPath{
        print("come in custom path 1")
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: UIScreen.width - 100, y: UIScreen.height - 60))
        
        let endPoint = CGPoint(x: 310, y: UIScreen.main.bounds.origin.x + 200)
        let randomXShift = 50 + drand48() * 100
        let c1 = CGPoint(x: 310 + randomXShift, y: 250)
        let c2 = CGPoint(x: 310 - randomXShift, y: 600 )
        path.addCurve(to: endPoint, controlPoint1: c1, controlPoint2: c2)
      //  path.addLine(to: endPoint)
        path.lineWidth = 3
       
        return path
    }

}





