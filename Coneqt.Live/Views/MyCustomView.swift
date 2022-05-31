//
//  MyCustomView.swift
//  Coneqt.Live
//
//  Created by Senarios on 05/01/2022.
//

import Foundation
import UIKit

class MyCustomView: UIView {

    let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()

    }

    required init?(coder: NSCoder) {
   //     fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        setup()
    }

 
    func setup(){
        

   
//        shapeLayer.contents = UIImage(systemName: "person.fill")?.cgImage
        let path = barPath()
        shapeLayer.path = path.cgPath
        
  //      shapeLayer.strokeColor = UIColor.white.cgColor
        //
     //   shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = UIColor.systemBackground.cgColor

        // add the new layer to our custom view
        self.layer.addSublayer(shapeLayer)
    }
    

    func barPath() -> UIBezierPath{

        
//        path.move(to: CGPoint(x: 2, y: 0))
//        path.addArc(withCenter: CGPoint(x: 2, y: 10), radius: 10, startAngle: CGFloat(Double.pi/2*3), endAngle: 0, clockwise: true)
//        path.addLine(to: CGPoint(x: 12, y: 50))
//        path.addArc(withCenter: CGPoint(x: 22, y: 50), radius: 10, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi/2), clockwise: false)
//        path.addLine(to: CGPoint(x: 100, y: 60))
//        path.addArc(withCenter: CGPoint(x: 100, y: 50), radius: 10, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(0), clockwise: false)
//        path.addLine(to: CGPoint(x: 110, y: 10))
//        path.addArc(withCenter: CGPoint(x: 120, y: 10), radius: 10, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi/2*3), clockwise: true)
//        path.close()


                let path = UIBezierPath()

        path.move(to: CGPoint(x: 2, y: 0))
        path.addArc(withCenter: CGPoint(x: 2, y: 10), radius: 10, startAngle: CGFloat(Double.pi/2*3), endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: 12, y: 50))
        path.addArc(withCenter: CGPoint(x: 20, y: 50), radius: 8, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi/2), clockwise: false)
        path.addLine(to: CGPoint(x: 80, y: 58))
        path.addArc(withCenter: CGPoint(x: 80, y: 50), radius: 8, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(0), clockwise: false)
        path.addLine(to: CGPoint(x: 88, y: 10))
        path.addArc(withCenter: CGPoint(x: 98, y: 10), radius: 10, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi/2*3), clockwise: true)
        path.close()
        return path

    }
    
    func moveShape(_ points : CGPoint){
        
        DispatchQueue.main.async {
            self.shapeLayer.position = points
        }
    }

}
