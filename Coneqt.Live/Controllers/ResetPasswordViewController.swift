//
//  ResetPasswordViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/22/21.
//

import UIKit
import Foundation

class ResetPasswordViewController: BaseViewController {
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var imgShowPassword: UIImageView!
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var imgBack: UIImageView!
    
    var emailAddress = ""
    
    @IBOutlet weak var txtPassword: UITextField!
    var showPassword: Bool = false
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setControls()
    }
    
    // MARK: - Class Functions
    func setControls(){
        self.view.backgroundColor = Colors.SCREENS_BACKGROUND_COLOR
        
        print("emailAddress :", emailAddress)
        self.vPassword.layer.cornerRadius = 5
        self.vPassword.layer.borderWidth = 1
        self.vPassword.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.imgShowPassword.image = SVGKImage(named: "eye_close").uiImage
        self.imgBack.image = SVGKImage(named: "back").uiImage
        
        self.btnConfirm.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
    }
    
    private func goToHome(){
//        Defaults.isUserLogin = true
//        let vc = ViewControllers.get(CreateFirstEvenViewController(), from: "Main")
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let controllers = self.navigationController?.viewControllers
         for vc in controllers! {
           if vc is SignInViewController {
             _ = self.navigationController?.popToViewController(vc as! SignInViewController, animated: true)
           }
        }
        
    }
    
    // MARK: - Control Actions
    @IBAction func Back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Confirm_Clicked(_ sender: Any) {
        let password = txtPassword.text!

        if password.isEmpty{
            Toast.show(message: "Please enter new password", controller: self)
        }
        else if !password.isValidPassword(){
            Toast.show(message: "Password must have minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character", controller: self)
        }
        else{
            ChangePassword()
        }
        
    }
    @IBAction func ShowPassword_Clicked(_ sender: Any) {
        self.showPassword = !self.showPassword
        if(self.showPassword){
            self.imgShowPassword.image = SVGKImage(named: "eye_open").uiImage
            self.txtPassword.isSecureTextEntry = false
        }
        else{
            self.imgShowPassword.image = SVGKImage(named: "eye_close").uiImage
            self.txtPassword.isSecureTextEntry = true
        }
        
    }
    
    
    // MARK: - Call API
    
    private func ChangePassword(){
        
        let password = txtPassword.text!
        print("New password is",password)
        
        
        let url  = URL(string: "\(APIEndPoints.baseUrl)/change_password")!
        let param = [
            "email": self.emailAddress,
            "password": password
            
        ]
        let call = APIManager(headerType: .none,parameters: param, url: url)
          startAnimating()
        call.post { [weak self] result in
            self?.stopAnimating()
            switch result{
            case .success(let json):
                print("json is",json)
                if let success = json["success"] as? Bool,
                let message = json["message"] as? String{
                    
                    if success{
                        self?.goToHome()
                    }else{
                        self?.showToastMessage(message: message)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
       
    }
    
}

