//
//  SignInViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/22/21.
//
import Firebase
import UIKit
import SVGKit
import Foundation
import StripeUICore
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import FBSDKLoginKit
import Alamofire

import AuthenticationServices




class SignInViewController: BaseViewController{
  
  //  @IBOutlet weak var btnFacebook: FBLoginButton!
    


    
    @IBOutlet weak var vHeader: UIView!
    @IBOutlet weak var VSocial: UIView!
    
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var vEmail: UIView!
    
    @IBOutlet weak var imgApple: UIImageView!
    @IBOutlet weak var vApple: UIView!
    
    @IBOutlet weak var imgGoogle: UIImageView!
    @IBOutlet weak var vGoogle: UIView!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    @IBOutlet weak var imgFacebook: UIImageView!
    @IBOutlet weak var vFacebook: UIView!
    
    @IBOutlet weak var imgShowPassword: UIImageView!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    @IBOutlet weak var lblSignInWith: UILabel!
    var showPassword: Bool = false
    
    @IBOutlet weak var constrSignUpBottom: NSLayoutConstraint!
    @IBOutlet weak var constrHaveAccountBottom: NSLayoutConstraint!
    @IBOutlet weak var constrSocialTop: NSLayoutConstraint!
    @IBOutlet weak var constrSignInWith: NSLayoutConstraint!
    
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setControls()
  
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        if screenHeight < 700{

            self.constrSignUpBottom.constant = 15
            self.constrHaveAccountBottom.constant = 15
            self.constrSocialTop.constant = 15
            self.constrSignInWith.constant = 25
            
            self.lblDontHaveAccount.layoutIfNeeded()
            self.lblSignInWith.layoutIfNeeded()
            self.btnSignUp.layoutIfNeeded()
            self.VSocial.layoutIfNeeded()
        
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
        
        self.vPassword.layer.cornerRadius = 5
        self.vPassword.layer.borderWidth = 1
        self.vPassword.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
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
        
        self.btnForgotPassword.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        self.btnSignIn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        self.btnSignUp.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        
        txtEmail.delegate = self
        txtEmail.returnKeyType = .next

    }
    
    func GoToDashBoard(){
        
        //  self.performSegue(withIdentifier: Constants.Segues.Welcome_To_Login, sender: self)
    }
    
    // MARK: - Control Actions
    @IBAction func ForgotPassword_Clicked(_ sender: Any) {
        self.performSegue(withIdentifier: Segues.Signin_To_ForgotPassword, sender: self)
    }
    
    @IBAction func SignUp_Clicked(_ sender: Any) {
        self.performSegue(withIdentifier: Segues.SignIn_To_Signup, sender: self)
    }
    
    @IBAction func SignIn_Clicked(_ sender: Any) {
        login()
       // self.performSegue(withIdentifier: Segues.SignIn_To_Signup, sender: self)
    }
    
    @IBAction func Apple_Clicked(_ sender: Any) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])

        controller.delegate = self
        controller.presentationContextProvider = self

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
    
    @IBAction func  didTapGoogleSignIn(_ sender : UIButton) {

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
    
    
    func login(){
        
        // validate
        let email = txtEmail.text!
        let password = txtPassword.text!
        if email.isEmpty{
            Toast.show(message: "Please Insert Your Email", controller: self)
        }
        else if !email.isValidEmail(){
            Toast.show(message: "Please Enter Valid Email", controller: self)
            view.endEditing(true)
        }else if password.isEmpty{
            Toast.show(message: "Please enter your password", controller: self)
        }else if password.count < 6{
            Toast.show(message: "Invalid Password", controller: self)
            view.endEditing(true)
        }else{
            
            
            let url  = URL(string: "\(APIEndPoints.baseUrl)/login")!
            
            let parameters = [
                
                "email":email,
                "password":password,
                "device_token":Defaults.fcmToken ?? ""
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
    
}


extension SignInViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txtPassword.becomeFirstResponder()
    }
    
    
}

extension SignInViewController {
    
    
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
        Defaults.phoneNumber = user.user?.phone ?? ""
        Defaults.isConnectAccountEnable = user.user?.stripe_payout ?? 0 == 0 ? false:true
        print("value of payout enable is",Defaults.isConnectAccountEnable)
        self.goToNextVC()
       
    }
    
    private func goToNextVC(){
        let vc = ViewControllers.get(TabBarVC(), from: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension SignInViewController : ASAuthorizationControllerDelegate {
    
  
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            switch authorization.credential {
                
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                
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

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
           return self.view.window!
    }
}

