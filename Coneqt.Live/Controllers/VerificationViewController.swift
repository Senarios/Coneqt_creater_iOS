//
//  VerificationViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/22/21.
//




import UIKit
import Foundation
import FirebaseAuth

class VerificationViewController: BaseViewController {
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var vCode1: UIView!
    @IBOutlet weak var vCode2: UIView!
    @IBOutlet weak var vCode3: UIView!
    @IBOutlet weak var vCode4: UIView!
    @IBOutlet weak var btnResendAgain: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var txtCode1: UITextField!
    @IBOutlet weak var txtCode2: UITextField!
    @IBOutlet weak var txtCode3: UITextField!
    @IBOutlet weak var txtCode4: UITextField!
    
    @IBOutlet weak var imgBack: UIImageView!
    
    var isFromForgotPassword = false
    var emailAddress = ""
    var phoneNumber = ""
    
    var resendTimer : Timer?
    var timerValue = 59
    var enterdVerificationCode = ""
    var code : Int = 0
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setControls()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
         if segue.identifier == Segues.ForgotPassword_to_ResetPassword {
            if let destinationVC = segue.destination as? ResetPasswordViewController
            {
                destinationVC.emailAddress = emailAddress
            }
        }
    }
    
    // MARK: - Class Functions
    func setControls(){
        
        print("ForgotPasswordDAta1 :", isFromForgotPassword)
        print("emailAddress :", emailAddress)
        
        print("veriffication code is",code)
        
        self.view.backgroundColor = Colors.SCREENS_BACKGROUND_COLOR
        self.vHeader.layer.cornerRadius = 80
        self.vHeader.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        
        self.vCode1.layer.cornerRadius = 5
        self.vCode1.layer.borderWidth = 1
        self.vCode1.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        
        self.vCode2.layer.cornerRadius = 5
        self.vCode2.layer.borderWidth = 1
        self.vCode2.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vCode3.layer.cornerRadius = 5
        self.vCode3.layer.borderWidth = 1
        self.vCode3.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vCode4.layer.cornerRadius = 5
        self.vCode4.layer.borderWidth = 1
        self.vCode4.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        txtCode1.delegate = self
        txtCode2.delegate = self
        txtCode3.delegate = self
        txtCode4.delegate = self
        
        
        txtCode1.keyboardType = .numberPad
        txtCode2.keyboardType = .numberPad
        txtCode3.keyboardType = .numberPad
        txtCode4.keyboardType = .numberPad
        
        txtCode1.addTarget(self, action: #selector(didTapVerficationField), for: .editingChanged)
        txtCode2.addTarget(self, action: #selector(didTapVerficationField), for: .editingChanged)
        txtCode3.addTarget(self, action: #selector(didTapVerficationField), for: .editingChanged)
        txtCode4.addTarget(self, action: #selector(didTapVerficationField), for: .editingChanged)
        
        txtCode1.becomeFirstResponder()
        
        self.imgBack.image = SVGKImage(named: "back").uiImage
        
//        if(phoneNumber.count > 0){
//            lblHeading.text = "Enter 4 digit code sent to \(self.phoneNumber)"
//        }
//        else
//        {
        lblHeading.text = "Please Enter 4 digit code we sent to your phone number"
//        }
        
        self.btnResendAgain.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        self.btnResendAgain.isEnabled = false
        self.StartResendTimer()
    }
    
    
    
    func StartResendTimer() {
      guard resendTimer == nil else { return }

        resendTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(FireResendTimer),
                                         userInfo: nil,
                                         repeats: true)
    }
    func StopResendTimer() {
        resendTimer?.invalidate()
        resendTimer = nil
    }
    
    @objc func FireResendTimer() {
        if (self.timerValue > 0){
            self.timerValue -= 1
            self.lblTimer.text = "00:" + (self.timerValue < 10 ? ("0" + String(self.timerValue)) : String(self.timerValue))
        }
        else
        {
            self.btnResendAgain.isEnabled = true
        }
    }
    
    func GoToDashBoard(){
        
        //  self.performSegue(withIdentifier: Constants.Segues.Welcome_To_Login, sender: self)
    }
    
    func ResendOTPCode(){
        let lemailAddress = self.emailAddress
        
        let url  = URL(string: "\(APIEndPoints.baseUrl)/forgot_password")!
        
        let parameters = [
            "email":lemailAddress
        ]
        
        let object = APIManager(headerType: .none, parameters: parameters, url: url)
        startAnimating()
        object.post(model: UserModel.self) { [weak self] response in
            self?.stopAnimating()
            switch response{
            case .success(let user):
                self?.showToast(message: user.message!)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    // MARK: - Control Actions
    @IBAction func Back_Clicked(_ sender: Any) {
        self.StopResendTimer()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ResendAgain_Clicked(_ sender: Any) {
        self.timerValue = 59
        self.btnResendAgain.isEnabled = false
        self.ResendOTPCode()
        
        
//        let controllers = self.navigationController?.viewControllers
//         for vc in controllers! {
//           if vc is SignInViewController {
//             _ = self.navigationController?.popToViewController(vc as! SignInViewController, animated: true)
//           }
//        }
     //   self.performSegue(withIdentifier: Segues.Signup_To_FirstEvent, sender: self)
       
       
    }
    
    
    
    private func goToHome(){
        Defaults.isUserLogin = true
        let vc = ViewControllers.get(CreateFirstEvenViewController(), from: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VerificationViewController : UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case txtCode1:
            return true
        case txtCode2:
            return txtCode1.text!.isEmpty ? false : true
        case txtCode3:
            return txtCode1.text!.isEmpty || txtCode2.text!.isEmpty ? false : true
        case txtCode4:
            return txtCode1.text!.isEmpty || txtCode2.text!.isEmpty || txtCode3.text!.isEmpty ? false : true
        default:
            return false
        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtCode1 || textField == self.txtCode2 || textField == self.txtCode3 || textField == self.txtCode4 {
            if range.location == 1 {
                return false
            }
        }
        return true
    }
    
    func keyboardInputShouldDelete(_ textField: UITextField) -> Bool {
        print("key board input should delete")
        return true
    }

}

// MARK:- Helper Extenstion
extension VerificationViewController{
    
    //MARK:- @OBJC FUNC
    
    @objc func didTapVerficationField(_ txtField : UITextField){
        if txtField.text!.count == 1{
            
            switch txtField {
            case txtCode1:
                enterdVerificationCode += txtCode1.text!
                txtCode2.becomeFirstResponder()
            case txtCode2:
                enterdVerificationCode += txtCode2.text!
                txtCode3.becomeFirstResponder()
            case txtCode3:
                enterdVerificationCode += txtCode3.text!
                txtCode4.becomeFirstResponder()
            case txtCode4:
                enterdVerificationCode += txtCode4.text!
                txtCode4.resignFirstResponder()
                if(self.isFromForgotPassword){
                    goPinCodeVerificationForgotPassword()
                }
                else
                {
                    goForPinCodeVerification()
                }
                
                print("tttfinal verification code is ",enterdVerificationCode)
                
            default:
                break
            }
        }else if txtField.text!.isEmpty{
            
            switch txtField {
            case txtCode1:
                txtCode1.resignFirstResponder()
            case txtCode2:
                txtCode1.becomeFirstResponder()
            case txtCode3:
                txtCode2.becomeFirstResponder()
            case txtCode4:
                txtCode3.becomeFirstResponder()
                
            default:
                break
            }
        }
    }
    
    private func goPinCodeVerificationForgotPassword(){
        print("verification pin is",enterdVerificationCode)
        var verificationCode = "\(self.txtCode1.text!)\(self.txtCode2.text!)\(self.txtCode3.text!)\(self.txtCode4.text!)"
        print("Verification \(verificationCode)")
        
        let url  = URL(string: "\(APIEndPoints.baseUrl)/verify_password_reset_code")!
        let param = [
            "email":self.emailAddress,
            "verification_code":verificationCode
            
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
                       // self?.goToHome()
                        //DispatchQueue.main.async {
                        self?.performSegue(withIdentifier: Segues.ForgotPassword_to_ResetPassword, sender: self)
                       // }
                    }else{
                        self?.showToastMessage(message: message)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
       
    }
    
    
    private func goForPinCodeVerification(){
        print("verification pin is",enterdVerificationCode)
        var verificationCode = "\(self.txtCode1.text!)\(self.txtCode2.text!)\(self.txtCode3.text!)\(self.txtCode4.text!)"
        print("Verification \(verificationCode)")
        
        let url  = URL(string: "\(APIEndPoints.baseUrl)/verify/user")!
        let param = [
            "userId":Defaults.userId,
            "otp":Int(verificationCode)
            
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
