//
//  GetStartedViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/22/21.
//

import UIKit
import Foundation
import SVGKit

class GetStartedViewController: UIViewController {
    
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var imgGetStarted: UIImageView!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setControls()
    }
    
    // MARK: - Class Functions
    func setControls(){
        self.view.backgroundColor = Colors.MAIN_BACKGROUND_COLOR
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.imgGetStarted.image = SVGKImage(named: "girl_taking_selfie").uiImage

        self.btnGetStarted.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        
    }
    
    func GoToDashBoard(){
        print("come in go to dashboards")
      
        if Defaults.isUserLogin{
            let vc = ViewControllers.get(TabBarVC(), from: "Main")
            navigationController?.pushViewController(vc, animated: true)
        }else{
            self.performSegue(withIdentifier: Segues.GetStarted_To_Signin, sender: self)
        }
        
       
//        let vc = ViewControllers.getViewController(viewController: SignInViewController(), storyboardName: "Main")
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Control Actions
    
    @IBAction func GetStarted_Handle(_ sender: Any) {
//        let numbers = [0]
//        let _ = numbers[1]
        self.GoToDashBoard()
    }
    
    // MARK: - Call API
    
}
