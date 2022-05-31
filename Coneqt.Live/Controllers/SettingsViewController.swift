//
//  SettingsViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/29/21.
//

import UIKit
import Foundation
import SafariServices
import StripeUICore

class SettingsViewController: BaseViewController {
    
    var viewModel : SettingsViewModel!
    
    @IBOutlet weak var lblSelectedImageName: UILabel!
    @IBOutlet weak var vSelectedImage: UIView!
    @IBOutlet weak var vHeader: UIView!
    @IBOutlet weak var lblBrowseImage: UILabel!
    @IBOutlet weak var lblConnectAccountStatus: UILabel!
    @IBOutlet weak var tvBlockedUsers: UITableView!
    @IBOutlet weak var imgNotification: UIImageView!
    
    @IBOutlet weak var lblNameCaption: UILabel!
    @IBOutlet weak var vNameBox: UIView!
    
    @IBOutlet weak var vNotification: UIView!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var imgStripe: UIImageView!
    
    @IBOutlet weak var lblNoBlockedUserFound: UILabel!
    @IBOutlet weak var vError: UIView!
    
    @IBOutlet weak var vFirstName: UIView!
    @IBOutlet weak var vLastName: UIView!
    @IBOutlet weak var vNickName: UIView!
    @IBOutlet weak var vconnectWithStripe: UIView!
    
    @IBOutlet weak var vEmail: UIView!
    @IBOutlet weak var vPhoneNumber: UIView!
  
    
    @IBOutlet weak var switchAllowNotifications: UISwitch!
    @IBOutlet weak var btnSaveAndContinue: UIButton!

    @IBOutlet weak var screenHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnLogout : UIButton!
    @IBOutlet weak var lblLogout : UILabel!
    @IBOutlet weak var imgLogoutIcon : UIImageView!
    
    @IBOutlet weak var imgUpdated: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    var showPassword: Bool = false
    var isImageUpdated: Bool = false
    var isNewImageSelected: Bool = false
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var stackIncompleteError: UIStackView!
    @IBOutlet weak var stackStripeAccount: UIStackView!
    
    var gBlockedUsers : [BlockUserItem] = []
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.TABBAR_BACKGROUNDS
        viewModel = SettingsViewModel(controller : self)
       
        self.setControls()
    }
    
    // MARK: - Class Functions
    func setControls(){
        imagePicker.delegate = self
        
        getUserData()
        
        self.view.backgroundColor = Colors.SCREENS_BACKGROUND_COLOR
        self.vHeader.layer.cornerRadius = 80
        self.vHeader.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        
        self.imgNotification.image = SVGKImage(named: "notification").uiImage
        self.imgError.image = SVGKImage(named: "error").uiImage
        self.imgStripe.image = SVGKImage(named: "stripe").uiImage
        
        self.txtEmail.isEnabled = false
        self.txtPhoneNumber.isEnabled = false
        
        self.vError.layer.borderColor = Colors.ERROR_BUTTON_BG.cgColor
        self.vError.layer.borderWidth = 1
        
        self.vFirstName.layer.cornerRadius = 5
        self.vFirstName.layer.borderWidth = 1
        self.vFirstName.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vLastName.layer.cornerRadius = 5
        self.vLastName.layer.borderWidth = 1
        self.vLastName.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vNickName.layer.cornerRadius = 5
        self.vNickName.layer.borderWidth = 1
        self.vNickName.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        self.vNickName.isHidden = true
        
        self.vEmail.layer.cornerRadius = 5
        self.vEmail.layer.borderWidth = 1
        self.vEmail.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vPhoneNumber.layer.cornerRadius = 5
        self.vPhoneNumber.layer.borderWidth = 1
        self.vPhoneNumber.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vNotification.isHidden = true
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.btnSaveAndContinue.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        
        let fontName = UIFont(name:"Montserrat-Bold", size:14)
        self.lblBrowseImage.font = fontName
        
        self.tvBlockedUsers.delegate = self
        self.tvBlockedUsers.dataSource = self
        self.tvBlockedUsers.register(BlockedUserTVC.getNib(), forCellReuseIdentifier: "\(BlockedUserTVC.self)")
        
        vconnectWithStripe.isUserInteractionEnabled = true
        vconnectWithStripe.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapConnectWithStripe)))
        
        
        
        imgLogoutIcon.image = SVGKImage(named: "icon_logout").uiImage
        lblLogout.font = Fonts.get(type: .Montserrat_Bold, size: 14)
        btnLogout.setTitle("", for: .normal)
        btnLogout.layer.cornerRadius = 10
        btnLogout.layer.borderColor = UIColor.black.cgColor
        btnLogout.layer.borderWidth = 1
        
     
        updateProfileData()
        
        
        imgUpdated.round()
        imgProfile.round()
        
        if(Defaults.imageUrl.count > 10){
            self.isImageUpdated = true
        }
        self.imgUpdated.sd_setImage(with: URL(string: Defaults.imageUrl ?? ""), placeholderImage: UIImage(named: "profilePlaceholder"))
        self.imgProfile.sd_setImage(with: URL(string: Defaults.imageUrl ?? ""), placeholderImage: UIImage(named: "profilePlaceholder"))
        
        getBlockedUsers()
        
        
     //   viewModel.checkConnectStatus()
         updateStripeButtonUI()
 
 
        
        
        
    }
    
    
    func update(){
        print("update func call accout enable is",Defaults.isConnectAccountEnable)
        getBlockedUsers()
        updateData()
      //  updateProfileData()
        
        if Defaults.isConnectAccountEnable{
            ///  if status already true no need to check again
            return
        }
        
        checkConnectAccountStatus { value in
            if value{
                Defaults.isConnectAccountEnable = true
                self.updateStripeButtonUI()
                print("come in make account enable true")
            }else{
                Defaults.isConnectAccountEnable = false
                print("come in make account enable false")
            }
        }

    }
    
    func updateNotificationDot(){
        if(Cashe.notificationCount == 0){
            self.vNotification.isHidden = true
        }
        else
        {
            self.vNotification.isHidden = false
        }
    }
    
    private func updateProfileData(){
        print("image url is",Defaults.imageUrl)
        let firstName = Defaults.firstName
        let lastName = Defaults.lastName
        let userName = "@"+Defaults.firstName+"_"+Defaults.lastName
        
        txtFirstName.text = firstName
        txtLastName.text = lastName
        txtUserName.text = userName
        txtEmail.text = Defaults.email
        txtPhoneNumber.text = Defaults.phoneNumber
        
        self.vNameBox.isHidden = true
        self.vSelectedImage.isHidden = true
        if Defaults.imageUrl.count == 0 {
            let selectedName = (Defaults.firstName.count > 0 ? String(Defaults.firstName.prefix(1)) : "") + (Defaults.lastName.count > 0 ? String(Defaults.lastName.prefix(1)) : "")
            
            self.lblNameCaption.text = selectedName
            self.lblSelectedImageName.text = selectedName
            self.vNameBox.isHidden = false
            self.vSelectedImage.isHidden = false
        }
    }
    
    private func updateStripeButtonUI(){
        print("update stripe button ui call")
        if Defaults.connectId == nil{
            lblConnectAccountStatus.text = "Connect with Stripe account & save"
            self.screenHeightConstraint.constant = 1300
        }else if !Defaults.isConnectAccountEnable{
            lblConnectAccountStatus.text = "Complete Stripe account & save"
            self.screenHeightConstraint.constant = 1300
        }else{

            self.stackIncompleteError.isHidden = true
            self.stackStripeAccount.isHidden = true
            self.screenHeightConstraint.constant = 1100
        }
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func didTapConnectWithStripe(){
        
        
        if Defaults.isConnectAccountEnable{
            ///  if status already true no need to check again
              updateStripeButtonUI()
            return
        }
        
        if let id = Defaults.connectId{
            print("go for completion of account")
            
            
            if Defaults.isConnectAccountEnable{
                ///  if status already true no need to check again
                updateStripeButtonUI()
                return
            }
            checkConnectAccountStatus { value in
                
                if value{
                    Defaults.isConnectAccountEnable = true
                    self.updateStripeButtonUI()
                }else{
                    self.viewModel.goOnboardingLink(id)
                }
            }
            
            
        } else{
            print("go for create account")
            viewModel.createConnectedAccount()
        }
        
        
    }
    
    // MARK: - Control Actions
    
    
    @IBAction func BrowseImage_Clicked(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func SaveAndContinue_Clicked(_ sender: Any) {
        
        if txtFirstName.text!.isEmpty{
            Toast.show(message: "name is Reuired", controller: self)
            return
        }
        startAnimating()
        let firstname = txtFirstName.text!
        let lastname = txtLastName.text!
        let parameters = [
            "first_name":firstname,
            "last_name":lastname
        ]

        guard let url = Methods.shared.stringToUrl(APIEndPoints.updateProfile) else {
            return
        }
        
        let selectedImage = self.isNewImageSelected ? imgUpdated.image?.resizedToGivenSize(imageSize: 500.0) : imgUpdated.image
        
        let object = APIManager(headerType: .backend, parameters: parameters, url: url)
        
        
        object.postFile1(image: (self.isImageUpdated ? selectedImage : nil)) { result in
            self.stopAnimating()

            switch result{
            case .success(let data):
                print("come in profile success")
                var profile : UpdateProfileModel?
            
                do{
                    profile = try JSONDecoder().decode(UpdateProfileModel.self, from: data)
                    
                }catch{
                    
                    print("come in catch",error.localizedDescription)
                    self.showToastMessage(message: error.localizedDescription)
                }
                     
                

                
                
                guard let profile = profile else {
                    print("come in return")
                    self.showToastMessage(message: "Come in return profile not found")
                    return
                }

                
                if !(profile.success){
                    print("come to show errortoast")
                    Toast.show(message: profile.message ?? "", controller: self)
                    return
                }
                print("before store defaults",Defaults.imageUrl)
                Defaults.imageUrl = profile.profile?.image_url ?? ""
                print("after sore new",Defaults.imageUrl)
                print("original backend url is",profile.profile?.image_url ?? "empty return")
              
                self.isNewImageSelected = false
                
                Defaults.firstName = profile.profile?.first_name ?? ""
                Defaults.lastName = profile.profile?.last_name ?? ""
               // self.isImageUpdated = false
                DispatchQueue.main.async{
                    self.imgProfile.sd_setImage(with: URL(string: Defaults.imageUrl), placeholderImage: UIImage(named: "profilePlaceholder"))
                   
                    self.updateProfileData()
                  
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
    }
    
    @IBAction func Notification_Clicked(_ sender: Any) {
        let vc = ViewControllers.get(NotificationViewController(), from: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapLogout(_ sender : UIButton){
        self.LogoutAPI()
        //Defaults.clear()
        //AppDelegate.goForUnAuthUser()
    }
    
    @IBAction func setNotifications_Change(_ sender: Any) {
        var isON = (sender as! UISwitch).isOn;
        print(isON)
        SetSendNotifications(isNotify: isON)
    }
    
    @IBAction func ChangePassword_Clicked(_ sender: Any) {
        print("didTapEditPassword")
        let vc = ViewControllers.get(ChangePasswordVC(), from: "Main")
        present(vc, animated: true)
    }
    // MARK: - Call API
    
    
    private func SetSendNotifications(isNotify: Bool){
        print("come to call setSendNotifications")
        let parameters = [
            "notify":isNotify ? 1 : 0
        ]
        let apiService = APIManager(controller: nil, headerType: .backend, parameters: parameters, endPoint: .setSendNotifications, method: .post)
        apiService.postTest(model: PreferencesModel.self) {[weak self] response in
            switch response{
            case .success(let model):
                if model.success{
                    print(model.message)
                }else{
                    print(model.message)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    private func checkConnectAccountStatus(onCompletion : @escaping (Bool) -> Void){
        print("come to call apicheckConnectAccountStatus")
        let apiService = APIManager(controller: nil, headerType: .backend, endPoint: .connectAccountStatus, method: .post)
        apiService.postTest(model: ConnectAccountStatus.self) {[weak self] response in
            switch response{
            case .success(let model):
                if model.success{
                    onCompletion(true)
                  
                }else{
                    onCompletion(false)
                    print("come in make accound enable false")
                }
            case .failure(let error):
                onCompletion(false)
                print(error.errorDescription)
            }
        }
    }
    
    private func getBlockedUsers(){
        guard let url = Methods.shared.stringToUrl(APIEndPoints.getBlockedusers) else{
            print("fail to get url")
            return
        }
        let api = APIManager(headerType: .backend, url: url)
        
        api.getModel(model: BlockedUserModel.self) { [weak self] response in
           
            switch response{
                
            case .success(let blockedUsers):
                if (blockedUsers.success!){
                    print("history Data",blockedUsers)
                   // onCompletion(blockedUsers.blockUsers)
                    print("BlockedUserData :::", blockedUsers.blockUsers)
                    if(blockedUsers.blockUsers != nil){
                        self!.gBlockedUsers = blockedUsers.blockUsers!
                        self!.tvBlockedUsers.reloadData()
                        self!.lblNoBlockedUserFound.isHidden = true
                    }
                    else
                    {
                        self!.gBlockedUsers.removeAll()
                        self!.tvBlockedUsers.reloadData()
                        self!.lblNoBlockedUserFound.isHidden = false
                    }
                }
                else
                {
                    print(blockedUsers.message!)
                }
                
                
               
            case .failure(let error):
                
                print("Fail to get the event history",error.localizedDescription)
            }
        }
    }
    
    private func getUserData(){
        guard let url = Methods.shared.stringToUrl(APIEndPoints.userData) else{
            print("fail to get url")
            return
        }
        let api = APIManager(headerType: .backend, url: url)
        
        api.getModel(model: GetUserDataModel.self) { [weak self] response in
           
            switch response{
                
            case .success(let blockedUsers):
                if (blockedUsers.success!){
                    print("history Data",blockedUsers)
                    print("BlockedUserData :::", blockedUsers.userData?.user.device_notification)
                    if(blockedUsers.userData?.user.device_notification == 0){
                        self?.switchAllowNotifications.isOn = false
                    }
                    else
                    {
                        self?.switchAllowNotifications.isOn = true
                    }
                }
                else
                {
                    print(blockedUsers.message!)
                }
                
                
               
            case .failure(let error):
                
                print("Fail to get the event history",error.localizedDescription)
            }
        }
    }
    
    func CallUnblockUser(_ id : Int){
        print("CallUnblockUser")
        guard let url = Methods.shared.stringToUrl(APIEndPoints.unblockuser) else{
            
            return
        }
        self.startAnimating()
        var parameters : [String:String] = [
            "content_viewer_id": "\(id)"
        ]
        let apiService = APIManager(controller: self, headerType: .backend, parameters: parameters, endPoint: .unblock_user, method: .post)
        apiService.postTest(model: UnblockUserModel.self) {[weak self] response in
            self?.stopAnimating()
            print("CallUnblockUser==", response)
            switch response{
            case .success(let user):
                print("CallUnblockUser:: ", user)
                self?.getBlockedUsers()
            case .failure(let error):
                self?.stopAnimating()
                print(error.errorDescription)
                self?.getBlockedUsers()
            }
        }
    }
    
    func LogoutAPI(){
        let param = [
            "type": "mobile"
        ]
       
        let call = APIManager(controller: self, headerType: .backend, parameters: param, endPoint: .logout, method: .post)
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        Defaults.clear()
                        AppDelegate.goForUnAuthUser()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gBlockedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var blockedUserData = self.gBlockedUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(BlockedUserTVC.self)") as! BlockedUserTVC
        cell.btnUnblock.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .bold)
        cell.lblUserName.text = blockedUserData.name
        if(blockedUserData.image_url == nil || blockedUserData.image_url!.count == 0){
            cell.vShowNameImage.isHidden = false
            cell.lblShowName.text = String(blockedUserData.name!.prefix(1))
        }
        else{
            cell.imgUser.sd_setImage(with: URL(string: blockedUserData.image_url!), placeholderImage: UIImage(named: "profilePlaceholder"))
        }
        cell.unblockTapCallback = {
            print("Unblock user :::", blockedUserData.id, blockedUserData.content_viewer_id)
            self.CallUnblockUser(blockedUserData.content_viewer_id!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
      
       // if let pickedImage = info[.originalImage] as? UIImage {
        if let pickedImage = info[.editedImage] as? UIImage {
                // imageViewPic.contentMode = .scaleToFill
            imgUpdated.image = pickedImage
            print(imgUpdated.image?.pngData())
            print("come in updated image")
        }
        self.vSelectedImage.isHidden = true
        self.isNewImageSelected = true
        self.isImageUpdated = true
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("Image cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
}



extension SettingsViewController : SFSafariViewControllerDelegate{
    
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // the user may have closed the SFSafariViewController instance before a redirect
        // occurred. Sync with your backend to confirm the correct state
        
        
        spinner.stopAnimating()
        
    }
    
    
  
}
