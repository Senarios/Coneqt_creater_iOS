//
//  SplashViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/22/21.
//

import UIKit
import Foundation

class SplashViewController: UIViewController {
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setControls()
    }
    
    // MARK: - Class Functions
    func setControls(){
        self.view.backgroundColor = Colors.MAIN_BACKGROUND_COLOR
      //  goToCheckAccountStatus()
        print("come in splash view controller")
        let delayInSeconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.GoToDashBoard()
        }
    }
    
    func GoToDashBoard(){
        self.performSegue(withIdentifier: Segues.Splash_to_GetStarted, sender: self)
    }
    
    private func goToCheckAccountStatus(){
        
        if !Defaults.isUserLogin && !Defaults.isConnectAccountEnable{
            /// user is not login so no need to check the connect  status & if status already true no need to check again
            return
        }
        
        
        
        let apiService = APIManager(controller: nil, headerType: .backend, endPoint: .connectAccountStatus, method: .post)
        apiService.postTest(model: ConnectAccountStatus.self) { response in
            switch response{
            case .success(let model):
                if model.success{
                    Defaults.isConnectAccountEnable = true
                }else{
                    Defaults.isConnectAccountEnable = false
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
        

    }
    
    // MARK: - Control Actions
    
    
    // MARK: - Call API
    
}
