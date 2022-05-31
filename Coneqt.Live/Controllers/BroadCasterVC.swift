//
//  BroadCasterVC.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 25/11/2021.
//

import UIKit
import AgoraRtcKit
import SwiftUI
import SDWebImage

class BroadCasterVC: BaseStreamVC {
    
    @IBOutlet weak var vHeader: UIView!
    @IBOutlet weak var vBody: UIStackView!
    @IBOutlet weak var vCross: UIView!
    @IBOutlet weak var vMic: UIView!
    @IBOutlet weak var vCamera: UIView!
    @IBOutlet weak var vViewers: UIView!
    @IBOutlet weak var txtViewers: UILabel!
    @IBOutlet weak var imgViewers: UIImageView!
    
    
    @IBOutlet weak var imgMicrophone: UIImageView!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var imgCross: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblEventDescription: UILabel!
    
    @IBOutlet weak var lblNameOption: UILabel!
    @IBOutlet weak var vNameOption: UIView!
    var event : Upcoming!
    
    var eventId : Int{
        event.id ?? 0
    }
    
    /// Event End Popup References
     @IBOutlet weak var endStreamPopUpView : UIView!
    @IBOutlet weak var btnCancel : UIButton!
    
    
    @IBAction func Cross_Clicked(_ sender: Any) {
        let vc = ViewControllers.get(StreamPopupViewController(), from: "Stream")
  
        vc.endNow =  {
            /// call end api here
            
            self.viewModel.endEvent(self.eventId)
            self.EndEventNow()
            self.navigationController?.popViewController(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }
    
    func EndEventNow(){
        print("End Event called .... ")
    }
    @IBAction func Camera_Clicked(_ sender: Any) {
        print("Camera_Clicked")
        viewModel.tapVideoToggle()
    }
    @IBAction func MicroPhone_Cliced(_ sender: Any) {
        print("MicroPhone_Cliced")
        viewModel.tapAudioToggle()
    }
    

    @IBOutlet weak var localView: UIView!
   
    
    var viewModel : BroadcasterViewModel!
    var speaker = true
    
    var videoToggle : Bool = false{
        
        didSet{
            print("video toogle did set run")
            let image = videoToggle == false ? SVGKImage(named: "video").uiImage : SVGKImage(named: "pause_video").uiImage
            imgCamera.image = image
        }
    }
    
    var audioToggle : Bool = false{
        
        didSet{
            print("audio toogle did set run")
            let image = audioToggle == false ? SVGKImage(named: "microphone").uiImage : SVGKImage(named: "mute_audio").uiImage
            imgMicrophone.image = image
        }
    }
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fStreamId = String(eventId)
        viewModel = BroadcasterViewModel(viewController: self, streamId: fStreamId)
        getAgoraCredentials()
        setupTableView()
        navigationController?.navigationBar.isHidden = true
        heartView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeart)))
        thumbView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didThumbView)))
 
        vViewers.isUserInteractionEnabled = true
        vViewers.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapViewers)))
        
        self.setControls()
        
        
        
    }
    
    func getAgoraCredentials(){
        print("getAgoraCredentials")
        viewModel.startEvent(eventId)
    }
    
   // MARK:- @IBACTION
    func setControls(){
        
        self.vCross.layer.cornerRadius = self.vCross.layer.bounds.height / 2
        self.vCross.backgroundColor = Colors.MAIN_BACKGROUND_COLOR
        self.imgCross.image = SVGKImage(named: "cross").uiImage
        self.vCross.layer.borderColor = UIColor.white.cgColor
        self.vCross.layer.borderWidth = 2
        
        self.vMic.layer.cornerRadius = self.vMic.layer.bounds.height / 2
        self.vMic.backgroundColor = Colors.MAIN_BACKGROUND_COLOR

        self.imgMicrophone.image = SVGKImage(named: "microphone").uiImage
        
        self.vCamera.layer.cornerRadius = self.vCamera.layer.bounds.height / 2
        self.vCamera.backgroundColor = Colors.MAIN_BACKGROUND_COLOR

        self.imgCamera.image = SVGKImage(named: "video").uiImage
        
        self.imgViewers.image = SVGKImage(named: "eye_view").uiImage
        
        imgProfile.round()
        self.imgProfile.sd_setImage(with: URL(string: Defaults.imageUrl), placeholderImage: UIImage(named: "profilePlaceholder"))
        
        lblName.text = Defaults.firstName + " " + Defaults.lastName
        lblEventTitle.text = event.name
        lblEventDescription.text = event.description
        Cashe.overViewScreenRefreshRequired = true
   
        self.vNameOption.isHidden = true
        if(Defaults.imageUrl == nil || Defaults.imageUrl.count == 0){
            self.vNameOption.isHidden = false
            let lNameData = (Defaults.firstName.count > 0 ? String(Defaults.firstName.prefix(1)) : "") + (Defaults.lastName.count > 0 ? String(Defaults.lastName.prefix(1)) : "")
            self.lblNameOption.text = lNameData
        }
 

    }

    @objc private func didTapHeart(){
        
        viewModel.rect(type: AnimationImage.heart.rawValue)
    }
    
    @objc private func didThumbView(){
        
        viewModel.rect(type: AnimationImage.thumb.rawValue)
        
    }
    
    @objc private func didTapSwitchCamera(){
        
        agoraKit?.switchCamera()
    }
    
    
    @objc private func didTapUsers(){
//        viewModel.goToParticipentsVC()
    }
//


    @objc private func didTapViewers(){
        print("come in tap viewers")
        let vc = ViewControllers.get(ParticipentViewController(), from : "Stream")
        print("tap on participents view controller and count is",viewModel.streamParticipents.count)
        vc.participents = viewModel.streamParticipents
        vc.eventId = eventId
        present(vc, animated: true)
    }
    
    

    


    
    
  //MARK:- Setup Methods
    
    
    
    func setupStream() {
        
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        viewModel.agoraKit = agoraKit
        viewModel.setupAgoraLocalView(streamId: fStreamId, agoraKit: agoraKit){[weak self] _ in
            let videoCanvas = AgoraRtcVideoCanvas()
            videoCanvas.uid = 0
            videoCanvas.renderMode = .fit
            videoCanvas.view = self?.localView
            self?.agoraKit?.setupLocalVideo(videoCanvas)
            self?.agoraKit!.startPreview()
            
        }
        
        
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }

}

// MARK:- UITableView Delegate & DataSource
extension BroadCasterVC : UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(StreamTableViewCell.self)") as! StreamTableViewCell
        let object = messages[indexPath.row]
        cell.message.text = object.message
        cell.userImage.sd_setImage(with: URL(string: object.url),placeholderImage : UIImage(named: "profilePlaceholder"))
        cell.name.text = object.name + " " + object.lastName
        if(object.url == nil || object.url.count == 0){
            cell.vNameBlock.isHidden = false
            let selectedName = ((object.name.count) > 0 ? String((object.name.prefix(1))).uppercased() : "") + ((object.lastName.count) > 0 ? String(object.lastName.prefix(1)).uppercased() : "")
            cell.lblNameOption.text = selectedName
        }
        else
        {
            cell.vNameBlock.isHidden = true
            cell.userImage.sd_setImage(with: URL(string: object.url), placeholderImage: UIImage(named: "profilePlaceholder"))
        }
        
        print("name",object.name,"message",object.message,"url",object.url)
        
        cell.backgroundColor = .clear
        return cell
    }
    
    
    
}

// MARK:- Agora Callbacks
extension BroadCasterVC: AgoraRtcEngineDelegate {
    
    
    
    
    // This callback is triggered when a remote host joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("come in the delegate didJoinedOfUid",uid)
        /// hit api of join event
        
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("come in did join channel")
        
    }
    
    
    func rtcChannelDidLeave(_ rtcChannel: AgoraRtcChannel, with stats: AgoraChannelStats) {
        print("rtcChannelDidLeave")
    }
    
    
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRejoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("did rejoin channel call ",channel," uid : ",uid)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        print("didLeaveChannelWith call and stats are",stats)
    }
    

}
