//
//  ChangePasswordVC.swift
//  Coneqt.Live
//
//  Created by Azhar on 4/15/22.
//

import UIKit

class ChangePasswordVC: BaseViewController {

    @IBOutlet weak var btnDismissPopup : UIButton!
    @IBOutlet weak var lblChangePassword : UILabel!
    
    @IBOutlet weak var vOldPassword: UIView!
    @IBOutlet weak var vNewPassword: UIView!
    @IBOutlet weak var vConfirmPassword: UIView!
    
    @IBOutlet weak var txtNewPassword : UITextField!
    @IBOutlet weak var imgShowNewPassword: UIImageView!
    @IBOutlet weak var btnShowNewPassword: UIButton!
    var showNewPassword: Bool = false
    
    
    @IBOutlet weak var txtOldPassword : UITextField!
    @IBOutlet weak var imgShowOldPassword: UIImageView!
    @IBOutlet weak var btnShowOldPassword: UIButton!
    var showOldPassword: Bool = false
    
    @IBOutlet weak var txtConfirmPassword : UITextField!
    @IBOutlet weak var imgShowConfirmPassword: UIImageView!
    @IBOutlet weak var btnShowConfirmPassword: UIButton!
    var showConfirmPassword: Bool = false
    
    @IBOutlet weak var btnSave : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    
    
    private func setupUI(){
        
        applyOnView(views: [vOldPassword,vNewPassword,vConfirmPassword])
        imgShowNewPassword.image = SVGKImage(named: "eye_close").uiImage
        imgShowOldPassword.image = SVGKImage(named: "eye_close").uiImage
        imgShowConfirmPassword.image = SVGKImage(named: "eye_close").uiImage
        btnShowNewPassword.setTitle("", for: .normal)
        btnShowOldPassword.setTitle("", for: .normal)
        btnShowConfirmPassword.setTitle("", for: .normal)
        lblChangePassword.font = Fonts.get(type: .Montserrat_Semibold, size: 16)
        btnSave.titleLabel?.font = Fonts.get(type: .Montserrat_Bold, size: 14)
        btnDismissPopup.setImage(SVGKImage(named: "multiply").uiImage, for: .normal)
        
    }
    
    
    private func applyOnView(views : [UIView]){
        
        views.forEach { view in
            
            view.layer.cornerRadius = 5
            view.layer.borderWidth = 1
            view.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        }
        
    }
    
    private func ChangePassword(){
        
        let oldPassword = self.txtOldPassword.text!
        let newPassword = self.txtNewPassword.text!
        let confirmPassword = self.txtConfirmPassword.text!
        
        let url  = URL(string: "\(APIEndPoints.cancelEvent)")!
        let param = [
            "old_password": oldPassword,
            "new_password": newPassword
        ] 
       
        let call = APIManager(controller: self, headerType: .backend, parameters: param, endPoint: .change_password_settings, method: .post)
          startAnimating()
        call.postTest(model: GenerelResponse.self) { [weak self] response in
            self?.stopAnimating()
            switch response{
            case .success(let object):
                print("json is",object)
                let success = object.success
                let message = object.message
                self?.showToastMessage(message: message)
                if(success){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        

    }
    
    
    @IBAction func didTapShowNewPassword(_ sender : UIButton){
        
   
            self.showNewPassword = !self.showNewPassword
            if(self.showNewPassword){
                self.imgShowNewPassword.image = SVGKImage(named: "eye_open").uiImage
                self.txtNewPassword.isSecureTextEntry = false
            }
            else{
                self.imgShowNewPassword.image = SVGKImage(named: "eye_close").uiImage
                self.txtNewPassword.isSecureTextEntry = true
            }
        
    }
    
    @IBAction func didTapOldPassword(_ sender : UIButton){
        
   
            self.showOldPassword = !self.showOldPassword
            if(self.showOldPassword){
                self.imgShowOldPassword.image = SVGKImage(named: "eye_open").uiImage
                self.txtOldPassword.isSecureTextEntry = false
            }
            else{
                self.imgShowOldPassword.image = SVGKImage(named: "eye_close").uiImage
                self.txtOldPassword.isSecureTextEntry = true
            }
        
    }
    
    @IBAction func didTapShowConfirmPassword(_ sender : UIButton){
        
   
            self.showConfirmPassword = !self.showConfirmPassword
            if(self.showConfirmPassword){
                self.imgShowConfirmPassword.image = SVGKImage(named: "eye_open").uiImage
                self.txtConfirmPassword.isSecureTextEntry = false
            }
            else{
                self.imgShowConfirmPassword.image = SVGKImage(named: "eye_close").uiImage
                self.txtConfirmPassword.isSecureTextEntry = true
            }
        
    }
    
    @IBAction func didTapDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapSave(_ sender: UIButton) {
        let oldPassword = self.txtOldPassword.text!
        let newPassword = self.txtNewPassword.text!
        let confirmPassword = self.txtConfirmPassword.text!
        
        if oldPassword.isEmpty{
            Toast.show(message: "Please enter old password", controller: self)
        }
        else if !newPassword.isValidPassword(){
            Toast.show(message: "New password must have minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character", controller: self)
        }else if (confirmPassword != newPassword){
            Toast.show(message: "New password and confirm new password does not match!", controller: self)
        }
        else
        {
            self.ChangePassword()
        }
        
    }
    
}

