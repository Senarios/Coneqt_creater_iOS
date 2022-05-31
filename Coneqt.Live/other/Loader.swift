//
//  Loader.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 09/12/2021.
//

import Foundation
import UIKit
import Lottie

class Loader : UIView{

    
    private let spinner : UIActivityIndicatorView = {
        
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.hidesWhenStopped = true
        return spinner
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func startAnimation(){
        spinner.startAnimating()
    }
    
    func stopAnimation(){
        spinner.stopAnimating()
    }
    
}




class Spinner : UIView{
    
  let mainView = UIView()
    var lottieView : AnimationView = {
       
        let animation = Animation.named("loader_black")
        let animationView = AnimationView(animation: animation)
        animationView.animationSpeed = 2.0
        animationView.loopMode = .loop
        return animationView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        lottieView.frame = CGRect(x: screenWidth/2-30, y: screenHeight/2-30, width: 60, height: 60)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating(){
        lottieView.play()
        isHidden = false
    }
    
    func stopAnimating(){
        lottieView.stop()
        isHidden = true
    }
    
    
    private func setupUI(){
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        
        mainView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        mainView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        self.addSubview(mainView)
        
        lottieView.backgroundColor = .white
        lottieView.layer.cornerRadius = 30
        lottieView.layer.shadowOffset = CGSize(width: 0, height: 0)
        lottieView.layer.shadowOpacity = 0.8
        isHidden = true
        //   layer.cornerRadius = 30
        //   backgroundColor = .white
        //   layer.shadowOffset = CGSize(width: 0, height: 0)
        //   layer.shadowOpacity = 0.8
        //   layer.shadowColor = UIColor.lightGray.cgColor
        //   isHidden = true
        
        mainView.addSubview(lottieView)
    }
}
