//
//  CreateEventViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/27/21.
//

import UIKit
import Foundation
import DropDown



protocol DelegateCreateEvent{
    
    func didCreateEvent()
}


class CreateEventViewController: BaseViewController {
    
  
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var lblNameCaption: UILabel!
    @IBOutlet weak var vNameBox: UIView!
    
    @IBOutlet weak var lblTypeOfEvent: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var vBrowseOuter: UIView!
    @IBOutlet weak var vBrowseInner: UIView!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var imgBrowse: UIImageView!
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var vNotification: UIView!
    @IBOutlet weak var lblCaptureImage: UILabel!
    @IBOutlet weak var vEventName: UIView!
    @IBOutlet weak var vEventDuration: UIView!
    @IBOutlet weak var vEventTime: UIView!
    @IBOutlet weak var vEventType: UIView!
    @IBOutlet weak var vDescription: UIView!
    @IBOutlet weak var vCostOfEvent: UIView!
    
    @IBOutlet weak var txtEventName: UITextField!
    @IBOutlet weak var txtEventTime: UITextField!
    @IBOutlet weak var txtEventDuration: UITextField!
    @IBOutlet weak var txtEventDescription: UITextField!
    @IBOutlet weak var txtEventCost: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    
    @IBOutlet weak var vEventTypeFilter: UIView!
    @IBOutlet weak var btnCreateEvent: UIButton!
    @IBOutlet weak var btnEventTime: UIButton!
    
    var isImageSelected: Bool = false
    var selectedDateTime = ""
    
    var eventDurationInSeconds = 0
    
    
    let randomTitle : [String] = ["Benefits Of Salah","Five Pillers of Islam","Daily Routine Suunah Azkar"]
    let randomDesc : [String] = [
        "Salah involves a certain level of physical activity which includes standing, bowing prostration and sitting consecutively. Each position involves the movement of different parts of the human body in ways that Some muscles contract isometrically (same length) and some contract in approximation or isotonically (same tension). ",
        "The five pillars – the declaration of faith (shahada), prayer (salah), alms-giving (zakat), fasting (sawm) and pilgrimage (hajj) – constitute the basic norms of Islamic practice. They are accepted by Muslims globally irrespective of ethnic, regional or sectarian differences.",
        "Daily adhkaar help you to reaffirm your tawhid daily and keep you close to Allah. They always remind a believer to accept his own weakness and remain in awe of His Lord "
    ]
  
    
    var delegate : DelegateCreateEvent?
    
    var imagePicker = UIImagePickerController()
    var dropDown : DropDown!
    var eventTime : String = ""
    var isInteractionEnable = 1
    var random : Int!
    var filterIndex = 0
    
    var eventTypes : [String]{
        
        var arr = [String]()
       
        for item in Cashe.filterModel?.filters ?? []{
            arr.append(item.name ?? "")
        }
        return arr
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.setControls()
    }

    // MARK: - Class Functions
    func setControls(){
        navigationController?.navigationBar.isHidden = true
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        txtEventDuration.delegate = self
        imagePicker.delegate = self
        self.view.backgroundColor = Colors.TABBAR_BACKGROUNDS
        self.vHeader.layer.cornerRadius = 80
        self.vHeader.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        
        self.vBrowseInner.layer.cornerRadius = 20
        self.vBrowseInner.addDashedBorder()
        
        self.vBrowseOuter.backgroundColor = UIColor.white
        self.vBrowseOuter.addShadow(offset: CGSize.init(width: 0, height: 0.3), color: UIColor.black, radius: 1.5, opacity: 0.2)
        
        self.vEventName.layer.cornerRadius = 5
        self.vEventName.layer.borderWidth = 1
        self.vEventName.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vEventTime.layer.cornerRadius = 5
        self.vEventTime.layer.borderWidth = 1
        self.vEventTime.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vEventDuration.layer.cornerRadius = 5
        self.vEventDuration.layer.borderWidth = 1
        self.vEventDuration.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vEventType.layer.cornerRadius = 5
        self.vEventType.layer.borderWidth = 1
        self.vEventType.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        self.vEventType.isUserInteractionEnabled = true
        self.vEventType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapEventTypeView)))
        
        self.vDescription.layer.cornerRadius = 5
        self.vDescription.layer.borderWidth = 1
        self.vDescription.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.vCostOfEvent.layer.cornerRadius = 5
        self.vCostOfEvent.layer.borderWidth = 1
        self.vCostOfEvent.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.imgBack.image = SVGKImage(named: "back").uiImage
        self.imgBrowse.image = SVGKImage(named: "browse_image").uiImage
        self.imgNotification.image = SVGKImage(named: "notification").uiImage
        self.imgDropDown.image = SVGKImage(named: "dropdownlist_head").uiImage
        
        let fontName = UIFont(name:"Montserrat-Bold", size:14)
        self.lblCaptureImage.font = fontName
        
        self.txtEventName.delegate = self
        self.txtEventCost.delegate = self
        
        /// setUp DropDown
        
        dropDown = DropDown(anchorView: vEventTypeFilter)
        dropDown.dataSource =  eventTypes
        dropDown.width = screenWidth - 70
        dropDown.direction = .bottom
        dropDown.selectionAction = {[weak self] index,value in
            self?.filterIndex = index
            self?.lblTypeOfEvent.textColor = .label
            self?.lblTypeOfEvent.text = value
            
        }
        
        
        self.btnCreateEvent.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        btnEventTime.setTitle("", for: .normal)
        
        txtViewDescription.font = Fonts.get(type: .Montserrat_Regular, size: 16)
        txtViewDescription.delegate = self
        txtViewDescription.text = "Description about Event"
        txtViewDescription.textColor = UIColor.lightGray
        
      //  random = Int.random(in: 0...2)
    //    txtEventName.text = randomTitle[random]
        self.vNameBox.isHidden = true
        if Defaults.imageUrl.count == 0 {
            self.lblNameCaption.text = (Defaults.firstName.count > 0 ? String(Defaults.firstName.prefix(1)) : "") + (Defaults.lastName.count > 0 ? String(Defaults.lastName.prefix(1)) : "")
            self.vNameBox.isHidden = false
        }
        self.updateNotificationDot()
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
    
    // MARK: - Control Actions
    
    @IBAction func CaptureImage_Clicked(_ sender: Any) {
        
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
    
    @IBAction func CreateEvent_Clicked(_ sender: Any) {

        if let parameters = valiate(){
            print("parameters are",parameters)
            guard let url = Methods.shared.stringToUrl(APIEndPoints.createEvent) else {
                print("fail to get the url")
                return
            }
            startAnimating()
            let eventImage = self.imgBrowse.image?.resizedToGivenSize(imageSize: 1500.0)
            
            let api = APIManager(headerType: .backend, parameters: parameters, url: url)
            
            api.postFile(image: eventImage) { [weak self] result in
                self?.stopAnimating()
                switch result{
                case .success(let json):
                    Toast.show(message: "Event Created", controller: self!)
                    NotificationCenter.default.post(name: NotificationName.RELOAD_EVENT, object: nil)
                    self?.handleResponse(json)
                case .failure(let error):
                    print("error",error.localizedDescription)
                }
            }
        }
    }
    
    private func handleResponse(_ json : [String:Any]){
        print("get link json is",json)
        guard
            let link = json["link"] as? [String:Any],
            let showLink = link["toShow"] as? String,
            let toOpen = link["toOpen"] as? String else{
                showToastMessage(message: "Fail to get the link")
                return
            }
        print("two show link is",showLink)
        print("two open link is",toOpen)
        
        let vc = ViewControllers.get(MainPopupViewController(), from: "Main")
        vc.link = showLink
        vc.openLink = toOpen
        vc.onCompletion = { value in
            print("completion hadler run")
            self.dismiss(animated: true)
        }
        present(vc, animated: true)
        
    }
    
    
    private func valiate() -> [String:Any]?{
        let name = txtEventName.text!
        let time = eventTime
        let duration = txtEventDuration.text!
        let type = lblTypeOfEvent.text!
        var description = txtViewDescription.text!
        description = description.replacingOccurrences(of: "Description about Event", with: "")
        let cost = txtEventCost.text!
      //  let durationValue = duration.replacingOccurrences(of: " Minutes", with: "")
        
      //  let components = description.components(separatedBy: .whitespaces)  // Word count
      //  let words = components.filter { !$0.isEmpty }
        
        
        let backendTime = eventTime
        let backendFormatter = DateFormatter()
        backendFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        backendFormatter.timeZone = TimeZone.current
        backendFormatter.locale = Locale.current
        let backendDate = backendFormatter.date(from: backendTime)

        let totalseconds = (backendDate!).timeIntervalSince(Date())
        
        
        if !self.isImageSelected{
            Toast.show(message: "Image is require", controller: self)
            return nil
        };
        if name.isEmpty{
            Toast.show(message: "Name is require", controller: self)
            return nil
        };if time.isEmpty{
            Toast.show(message: "Time is require", controller: self)
            return nil
        };
        if((Int(totalseconds) < 0)){
            self.showToastMessage(message: "Event time can not be past time")
            return nil
        };
        if duration.isEmpty{
            Toast.show(message: "Duration is require", controller: self)
            return nil
        };if type.isEmpty{
            Toast.show(message: "Type is require", controller: self)
            return nil
        };if description.isEmpty{
            Toast.show(message: "Description is require", controller: self)
            return nil
        };if cost.isEmpty{
            Toast.show(message: "Cost is require", controller: self)
            return nil
        }
        if eventDurationInSeconds > 86400 {
            Toast.show(message: "Duration should not greater than 24 hours", controller: self)
            return nil
        }
        if description.count > 200 {
            Toast.show(message: "Description should be less than 200 characters", controller: self)
            return nil
        }
//        if (words.count - 1) > 150{
//            Toast.show(message: "Description should be less than 150 words", controller: self)
//            return nil
//        };
        
        let param : [String:Any] = [
            "name":name,
            "type":typeId() ?? "0",
            "time":time,
            "description":description,
            "time_duration":String(eventDurationInSeconds),
            "ticket_price":cost,
            "stream_interaction": isInteractionEnable == 1 ? "1" : "0"    // isInteractionEnable
        ]
        print("param of create event is",param)
        return param
    }
    
    private func typeId() -> String?{
        
        guard
            let id = Cashe.filterModel?.filters?[filterIndex].id else{
                return nil
            }
        print("filter id is",id)
        return String(id)
        
    }
    
    @IBAction func didTapUISwitch(_ sender: UISwitch) {
        
        isInteractionEnable = sender.isOn ? 1 : 0
    }
    @IBAction func Notification_Clicked(_ sender: Any) {
        let vc = ViewControllers.get(NotificationViewController(), from: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Back_Clicked(_ sender: Any) {
        dismissVC()
    }
    
    @IBAction func CopyLink_Clicked(_ sender: Any) {
      //  UIPasteboard.general.string = "Hello world"
    }
    
    @IBAction func didTapEventTime(_ sender: Any) {
        
        let vc = ViewControllers.get(DatePickerViewController(), from : "Main")
        vc.onCompletion = {[weak self] time in
            
            self?.selectedDateTime = time
            self?.eventTime = time
            self?.txtEventTime.text = Methods.shared.convertDate24To12(date: time)
            
        }
        present(vc, animated: true, completion: nil)
        
    }
    
    // MARK: - Call API
    
}
extension CreateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
       // if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imgBrowse.image = image
        }
        self.isImageSelected = true
//        if let pickedImage = info[.editedImage] as? UIImage {
//            imgBrowse.image = pickedImage
//            }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("Image cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
}


extension CreateEventViewController{
    
    //MARK:- @OBJC FUNC
    
    @objc func didTapEventTypeView(){
        dropDown.show()
    }
}


extension CreateEventViewController : UITextFieldDelegate,UITextViewDelegate    {
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        switch textField {
        case txtEventDuration:
            print("textFieldShouldBeginEditing")
            txtEventDuration.text = ""
            return true
        default:
            return true
        }

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing")
        switch textField {
        case txtEventDuration:
           /* if txtEventDuration.text!.count > 0{
                var eventDurationText = txtEventDuration.text!
                let eventInMinutes = Int(eventDurationText)!
                eventDurationInSeconds = eventInMinutes * 60
                let lHours = eventInMinutes / 60
                if(lHours > 24){
                    Toast.show(message: "Duration should not greater than 24 hours", controller: self)
                }
                
                return true
            }*/
            if txtEventDuration.text!.count > 0 { //}&& txtEventDuration.text!.count < 5{
                var eventDurationText = txtEventDuration.text!
                eventDurationText = eventDurationText.replacingOccurrences(of: "h ", with: "")
                eventDurationText = eventDurationText.replacingOccurrences(of: "h", with: "")
                eventDurationText = eventDurationText.replacingOccurrences(of: "min", with: "")
                let eventInMinutes = Int(eventDurationText)!
                eventDurationInSeconds = eventInMinutes * 60
                print("event duration is seconds is",eventDurationInSeconds)
                
                let lHours = eventInMinutes / 60
                let lMinutes = eventInMinutes % 60
                
                var eventDurationData = ""
                if(lHours > 0){
                    eventDurationData = "\(lHours)h "
                }
                if(lMinutes > 0){
                    eventDurationData += "\(lMinutes)min"
                }
                
                if(lHours > 24){
                    Toast.show(message: "Duration should not greater than 24 hours", controller: self)
                }
                else
                {
                    txtEventDuration.text = eventDurationData // txtEventDuration.text!+" Minutes"
                }
                
                return true
            }
           
            return true
        default:
            return true
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtViewDescription.textColor == UIColor.lightGray {
            txtViewDescription.text = txtViewDescription.text.replacingOccurrences(of: "Description about Event", with: "")
          //  txtViewDescription.text = nil
            txtViewDescription.textColor = UIColor.black
         //   txtViewDescription.text = randomDesc[random]
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(txtViewDescription.text.count == 0){
            txtViewDescription.text = "Description about Event"
            txtViewDescription.textColor = UIColor.lightGray
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtEventName {
            if range.location > 25 {
                return false
            }
        }
        if textField == self.txtEventCost {
            if range.location > 5 {
                return false
            }
        }
        return true
    }
}
