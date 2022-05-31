//
//  SignUpViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/22/21.
//

import UIKit
import Foundation
import AuthenticationServices
import GoogleSignIn
import FBSDKLoginKit

class SignUpUserViewController: BaseViewController {
    
    var viewModel : SignUpVieModel!
    
    @IBOutlet weak var vFirstName: UIView!
    @IBOutlet weak var vLastName: UIView!
    @IBOutlet weak var vPhoneNumber: UIView!
    
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var vEmail: UIView!
    
    @IBOutlet weak var imgApple: UIImageView!
    @IBOutlet weak var vApple: UIView!
    
    @IBOutlet weak var imgGoogle: UIImageView!
    @IBOutlet weak var vGoogle: UIView!
    
    @IBOutlet weak var imgFacebook: UIImageView!
    @IBOutlet weak var vFacebook: UIView!
    
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var imgShowPassword: UIImageView!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnTermsAndConditions: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    var showPassword: Bool = false
    var termsAndConditionsAccepted: Bool = false
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SignUpVieModel(controller: self)
        self.setControls()
    }
    

    
    // MARK: - Class Functions
    func setControls(){
        self.view.backgroundColor = Colors.SCREENS_BACKGROUND_COLOR
        self.vHeader.layer.cornerRadius = 80
        self.vHeader.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        
        self.vEmail.layer.cornerRadius = 5
        self.vEmail.layer.borderWidth = 1
        self.vEmail.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vPassword.layer.cornerRadius = 5
        self.vPassword.layer.borderWidth = 1
        self.vPassword.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vFirstName.layer.cornerRadius = 5
        self.vFirstName.layer.borderWidth = 1
        self.vFirstName.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vLastName.layer.cornerRadius = 5
        self.vLastName.layer.borderWidth = 1
        self.vLastName.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vPhoneNumber.layer.cornerRadius = 5
        self.vPhoneNumber.layer.borderWidth = 1
        self.vPhoneNumber.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vFacebook.layer.cornerRadius = self.vFacebook.layer.bounds.height / 2
        self.vFacebook.backgroundColor = Colors.MAIN_BACKGROUND_COLOR
        self.imgFacebook.image = SVGKImage(named: "facebook").uiImage
        
        self.vApple.layer.cornerRadius = self.vApple.layer.bounds.height / 2
        self.vApple.backgroundColor = Colors.MAIN_BACKGROUND_COLOR
        self.imgApple.image = SVGKImage(named: "apple").uiImage
        
        self.vGoogle.layer.cornerRadius = self.vGoogle.layer.bounds.height / 2
        self.vGoogle.backgroundColor = Colors.MAIN_BACKGROUND_COLOR
        self.imgGoogle.image = SVGKImage(named: "google").uiImage
        
        self.imgShowPassword.image = SVGKImage(named: "eye_close").uiImage
        self.imgCheckBox.image = SVGKImage(named: "checkbox_uncheck").uiImage
        
        self.imgBack.image = SVGKImage(named: "back").uiImage
        
       // self.btnTermsAndConditions.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        self.btnContinue.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        
    }
    
    func GoToDashBoard(){
        
        //  self.performSegue(withIdentifier: Constants.Segues.Welcome_To_Login, sender: self)
    }
    
    // MARK: - Control Actions
    
    @IBAction func Back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func AcceptTermsAndCondition_Clicked(_ sender: Any) {
        self.termsAndConditionsAccepted = !self.termsAndConditionsAccepted
        if(self.termsAndConditionsAccepted){
            self.imgCheckBox.image = SVGKImage(named: "checkbox_check").uiImage
            imgCheckBox.tag = 1
        }
        else
        {
            self.imgCheckBox.image = SVGKImage(named: "checkbox_uncheck").uiImage
            imgCheckBox.tag = 0
        }
        
    }
    @IBAction func TermsAndConditions_Clicked(_ sender: Any) {
        
    } //checkbox_check
    
    @IBAction func Continue_Clicked(_ sender: Any) {
        viewModel.SignUp()
      //  self.performSegue(withIdentifier: Segues.SignUp_To_Verification, sender: self)
    }
    
    @IBAction func Apple_Clicked(_ sender: Any) {
        let appleIDDetail = ASAuthorizationAppleIDProvider()
        let request = appleIDDetail.createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
        
    }
    
    @IBAction func Facebook_Clicked(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile","email"], from: self) { result, error in
            // Process result or error
            print("Facebook login Result",result, error)
            
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }

            self.getFBUserData()
        }


      /*  let fbCall = FacebookManager.shared
        fbCall.getProfile(vc: self) {[weak self] response in
            switch response{
            case .success(let json):
                self?.handleFbProfileResponse(json)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }*/
    }
    
    @IBAction func Google_Clicked(_ sender: Any) {
        
        let googleService = GoogleManager.shared
        googleService.getProfile(vc: self) {[weak self] response in
            switch response{
            case .success(let user):
                self?.handleGoogleProfileResponse(user)
                    
            case .failure(let error):
                print(error.localizedDescription)
                
                
            }
        }
    }
    
    private func handleGoogleProfileResponse(_ user : GIDGoogleUser){
        
        let fName = user.profile?.name ?? ""
        let lName = user.profile?.givenName ?? ""
        let email = user.profile?.email ?? ""
        let img = user.profile?.imageURL(withDimension: 320)?.absoluteString ?? ""
        
        let id = user.userID ?? "12345"
        
        print(user.profile?.name)
        print(user.profile?.givenName)
        print(user.profile?.email)
        print(user.profile?.imageURL(withDimension: 320))
        print(user.userID)

        /// Now call the backend api
        let parameters : [String:String] = [
            "first_name":fName,
            "last_name":lName,
            "email":email,
            "id":id,
            "image_url":img,
            "device_token":Defaults.fcmToken ?? "",
            "auth_type":"google"
         
        ]
        self.socialLoginRequest(parameters: parameters)

    }
    
    fileprivate func getFBUserData(){
            if((AccessToken.current) != nil){
                GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let dict = result as? [String : AnyObject]
                        print(result!)
                        print(dict)

                        guard let Username = dict!["name"]! as? String else { return }
                        guard let UserId = dict!["id"]! as? String else { return }
                        guard let Useremail = dict!["email"]! as? String else { return }
                        guard let first_name = dict!["first_name"]! as? String else { return }
                        guard let last_name = dict!["last_name"]! as? String else { return }
                        let picture = dict!["picture"] as? [String:Any]
                        var data = picture!["data"] as? [String:Any]
                        var pictureUrl = data!["url"] as? String
                       
                        let parameters = [
                            "first_name":first_name,
                            "last_name":last_name,
                            "email":Useremail,
                            "id":UserId,
                            "image_url":pictureUrl!,
                            "device_token":Defaults.fcmToken ?? "",
                            "auth_type":"facebook"
                        ]
                        
                        self.socialLoginRequest(parameters: parameters)
                }
            })
        }
    }
    
    @IBAction func ShowPassword_Clicked(_ sender: Any) {
        print("show password")
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
    
    //MARK: Social Login Request
    private func handleFbProfileResponse(_ result : [String:Any]){
        
        guard let firstName = result["first_name"] as? String,
              let lastName = result["last_name"] as? String,
              let id = result["id"] as? String,
              let picture = result["picture"] as? [String:Any],
              let data = picture["data"] as? [String:Any],
              let pictureUrl = data["url"] as? String
            //  let userEmail = result["email"] as? String
        else{
                  print("Failed to get FB user name and password")
                  return
              }
        
        /// Now call the backend api
        let parameters = [
            "first_name":firstName,
            "last_name":lastName,
            "id":id,
            "image_url":pictureUrl,
            "device_token":Defaults.fcmToken ?? "",
            "auth_type":"facebook"
         
        ]
        
        socialLoginRequest(parameters: parameters)
   
    }
    
    private func socialLoginRequest(parameters : [String:String]){
        
        let apiService = APIManager(controller: self, headerType: .none, parameters: parameters, endPoint: .socialLogin, method: .post)
        startAnimating()
        apiService.postTest(model: UserModel.self) {[weak self] response in
            self?.stopAnimating()
            switch response{
            case .success(let user):
                self?.setUserDefaults(user)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    // MARK: - Call API
    
}

extension SignUpUserViewController{
    
    
    private func handleResponse(_ user : UserModel){
        
        setUserDefaults(user)
    }
    
    private func setUserDefaults(_ user : UserModel){
        print("come in setUserDefaults",user)
        guard
            let success = user.success,
            let message = user.message else{
            return
        }
        
        if !success{
            Toast.show(message: message, controller: self)
            return
        }
        
        
        guard
            let token = user.user?.api_token,
            let email = user.user?.email,
            let userId = user.user?.id else{
                Toast.show(message: "Email & token is empty ", controller: self)
                return
            }
        
        Defaults.isUserLogin = true
        Defaults.userId = userId
        Defaults.backEndToken = token
        Defaults.email = email
        Defaults.backEndToken = token
        Defaults.connectId = user.user?.stripe_account_id
        Defaults.firstName = user.user?.first_name ?? ""
        Defaults.lastName = user.user?.last_name ?? ""
        Defaults.imageUrl = user.user?.image_url ?? ""
        Defaults.isConnectAccountEnable = user.user?.stripe_payout ?? 0 == 0 ? false:true
        print("value of payout enable is",Defaults.isConnectAccountEnable)
        self.goToNextVC()
       
    }
    
    private func goToNextVC(){
        let vc = ViewControllers.get(TabBarVC(), from: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension SignUpUserViewController: ASAuthorizationControllerDelegate{
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print(appleIDCredential.user)
            
            var parameters : [String:String] = [
              
                "id":appleIDCredential.user,
                "device_token":Defaults.fcmToken ?? "6754",
                "auth_type":"apple"
                
            ]
            
            print("useridentifier is",appleIDCredential.user)
            
            if let email = appleIDCredential.email{
                print("come in email")
                parameters["email"] = email
            }
            
            UserDefaults.standard.set("AppleAuthId", forKey: appleIDCredential.user)
            
            
            if let name = appleIDCredential.fullName?.description{
                print("come in first name", name)
                parameters["first_name"] = name.count == 0 ? "..  " : name
                
                
            }else{
                print("fail to get the value name")
            }
            
            print("params before login request",parameters)
            self.socialLoginRequest(parameters: parameters)
      
            break
        default:
            break
        }
    }
}
