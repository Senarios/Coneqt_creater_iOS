//
//  ForgotPasswordViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/22/21.
//

import UIKit
import Foundation

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var vEmailPopUp: UIView!
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var vEmail: UIView!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var txtEmailAddress: UITextField!
    
    var emailAddress = ""
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setControls()
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
         if segue.identifier == Segues.ForgotPassword_to_Verification {
            if let destinationVC = segue.destination as? VerificationViewController
            {
                destinationVC.isFromForgotPassword = true
                destinationVC.emailAddress = emailAddress
            }
        }
    }
    
    // MARK: - Class Functions
    func setControls(){
        self.view.backgroundColor = Colors.SCREENS_BACKGROUND_COLOR
        self.vHeader.layer.cornerRadius = 80
        self.vHeader.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        
        self.vEmail.layer.cornerRadius = 5
        self.vEmail.layer.borderWidth = 1
        self.vEmail.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vEmailPopUp.isHidden = true
        
        self.imgBack.image = SVGKImage(named: "back").uiImage
        
        self.btnSend.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
       
        
    }
    
    
    // MARK: - Control Actions
    @IBAction func Back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Send_Clicked(_ sender: Any) {
     //   self.vEmailPopUp.isHidden = false
        
        let email = txtEmailAddress.text!

        if email.isEmpty{
            Toast.show(message: "Please Insert Your Email", controller: self)
        }
        else if !email.isValidEmail(){
            Toast.show(message: "Please Enter Valid Email", controller: self)
            view.endEditing(true)
        }
        else
        {
            emailAddress = email
            
            let url  = URL(string: "\(APIEndPoints.baseUrl)/forgot_password")!
            
            let parameters = [
                "email":email
            ]
            
            let object = APIManager(headerType: .none, parameters: parameters, url: url)
            startAnimating()
            object.post(model: UserModel.self) { [weak self] response in
                self?.stopAnimating()
                switch response{
                case .success(let user):
                    self?.handleResponse(user)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    @IBAction func GoToEmail_Clicked(_ sender: Any) {
        self.vEmailPopUp.isHidden = true
        self.performSegue(withIdentifier: Segues.ForgotPassword_To_ResetPassword, sender: self)
    }
    
    // MARK: - Call API
    
}

extension ForgotPasswordViewController {
    
    
    private func handleResponse(_ user : UserModel){
        print(user)
        print(user.success!)
        if(user.success!){
            Toast.show(message: user.message!, controller: self)
        
            self.performSegue(withIdentifier: Segues.ForgotPassword_to_Verification, sender: self)
        }
        else
        {
            Toast.show(message: user.message!, controller: self)
        }
        print(user.message!)
      //  setUserDefaults(user)
    }
}
