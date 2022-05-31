//
//  SignUpViewModel.swift
//  Coneqt.Live
//
//  Created by Senarios on 13/01/2022.
//

import Foundation
import StripeUICore

class SignUpVieModel{
    
    let controller : SignUpUserViewController!
    
    init(controller : SignUpUserViewController){
        self.controller = controller
    }
    
    
    
    
    func SignUp(){
        let firstName = controller.txtFirstName.text!
        let lastName = controller.txtLastName.text!
        let phoneNumber = controller.txtPhoneNumber.text!
        var email = controller.txtEmail.text!
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = controller.txtPassword.text!
        let termsAndCondition = controller.imgCheckBox.tag
        
        if firstName.isEmpty{
            Toast.show(message: "Please Enter Your first Name", controller: controller)
        }else if lastName.isEmpty{
            Toast.show(message: "Please Enter Your last Name", controller: controller)
        }else if phoneNumber.isEmpty{
            Toast.show(message: "phone number is reqiure", controller: controller)
        }else if phoneNumber.count < 11{
            Toast.show(message: "please enter valid phone number", controller: controller)
        }
        else if email.isEmpty{
            Toast.show(message: "Please Insert Your Email", controller: controller)
        }
        else if !email.isValidEmail(){
            Toast.show(message: "Please Enter Valid Email", controller: controller)
        }else if password.isEmpty{
            Toast.show(message: "Please enter your password", controller: controller)
        }else if !password.isValidPassword(){
            Toast.show(message: "Password must have minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character", controller: controller)
        }else if termsAndCondition == 0{
            Toast.show(message: "Accept terms And condition to continue", controller: controller)
        }else{
            print("api call")
            let url  = URL(string: "\(APIEndPoints.baseUrl)/signup")!
            let param  = [
                "email":email,
                "password":password,
                "phone":phoneNumber,
                "first_name":firstName,
                "last_name":lastName,
                "device_token":Defaults.fcmToken ?? ""
           
            ]
            let call = APIManager(headerType: .none,parameters: param, url: url)
            self.controller.startAnimating()
            call.post { result in
                self.controller.stopAnimating()
                switch result{
                case .success(let json):
                    if let success = json["success"] as? Bool,
                    let message = json["message"] as? String{
                        
                        if !success{
                            Toast.show(message: message, controller: self.controller)
                        }
                    }
                    
                    let data = json["data"] as? [String:Any]
                    guard let token = data?["api_token"] as? String,
                          let userId = data?["id"] as? Int,
                          let verificationCode = data?["verification_code"] as? Int,
                          let email = data?["email"] as? String else{
                        print("return from tokern not found")
                        return
                    }
                    
                    
                    Defaults.firstName = data?["first_name"] as? String ?? ""
                    Defaults.lastName = data?["last_name"] as? String ?? ""
                    Defaults.userId = userId
                    
                    Defaults.backEndToken = token
                    Defaults.email = email
                    Defaults.phoneNumber = phoneNumber
                    
                    self.goForVerification(verificationCode)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            return
        }
        controller.view.endEditing(true)
       
    }
    
    
}


extension SignUpVieModel {
    
    private func goForVerification(_ code : Int){
        var email = controller.txtEmail.text!
        let phoneNumber = controller.txtPhoneNumber.text!
        let vc = ViewControllers.get(VerificationViewController(), from: "Main")
        vc.code = code
        vc.phoneNumber = phoneNumber
        vc.emailAddress = email
        controller.navigationController?.pushViewController(vc, animated: true)
        
    }
}
