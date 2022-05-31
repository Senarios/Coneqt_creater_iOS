//
//  BroadCasterViewModel.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 29/11/2021.
//

import Foundation
import UIKit
import AgoraRtcKit
import Stripe
import FirebaseDatabase







//
//  BroadCasterViewModel.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 29/11/2021.
//

import Foundation
import UIKit
import AgoraRtcKit
import Stripe
import FirebaseDatabase




class BroadcasterViewModel{
    
    var vc : BroadCasterVC!
    var streamId : String!
    var agoraKit: AgoraRtcEngineKit?
    let basePath : String
    
    var streamParticipents = [StreamParticipent]()
    
    init(viewController : BroadCasterVC,streamId : String){
        self.vc = viewController
        self.streamId = streamId
        self.basePath = "streams/\(streamId)"
    }
    
    // MARK:- Agora
    func setupAgoraLocalView(streamId : String, agoraKit : AgoraRtcEngineKit?,onCompletion : @escaping (Bool) -> Void){
        
        
        agoraKit?.setChannelProfile(.liveBroadcasting)
        let options: AgoraClientRoleOptions = AgoraClientRoleOptions()
        options.audienceLatencyLevel = AgoraAudienceLatencyLevelType.lowLatency
        agoraKit?.setClientRole(.broadcaster, options: options)
        agoraKit?.enableVideo()
        
        agoraKit?.joinChannel(byToken: KeyCenter.token, channelId: KeyCenter.channelName, info: nil, uid: UInt(streamId)!, joinSuccess: { channel, uid, elapsed in
            onCompletion(true)
        })

    }
    
    
    
    private func setupFirebase(){
        
        createFirebaseStream()
        fetchChat()
        fetchReaction()
        observeParticipents()
    }

    
    
    func tapVideoToggle(){
        
        let result = Methods.shared.toggle(&vc.videoToggle)
        agoraKit?.muteLocalVideoStream(result)
        let status = result == true ? VideoStatus.disable : VideoStatus.enable
        let path = FirebaseManager.shared.ref.child("\(basePath)/status")
        let value = [
            
            "video":status.rawValue
        ]
        
        FirebaseManager.shared.update(path: path, value: value) { response in
            
            switch response{
            
            case .success(let success):
                success == true ? print("Updated") : print("Fail to Update")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tapAudioToggle(){
        
        let result = Methods.shared.toggle(&vc.audioToggle)
        let status = result == true ? AudioStatus.mute : AudioStatus.unmute
        agoraKit?.muteLocalAudioStream(result)
        let path = FirebaseManager.shared.ref.child("\(basePath)/status")
        let value = [
            
            "audio":status.rawValue
        ]
        
        FirebaseManager.shared.update(path: path, value: value) { response in
            
            switch response{
            
            case .success(let success):
                success == true ? print("Updated") : print("Fail to Update")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
    
    
    
    /// Firebase Function here
    
    func createFirebaseStream(){
        /// craete stream
        FirebaseManager.shared.createFirebaseStream(streamId: streamId)
    }
    
    
    func fetchChat(){
        /// listen chat

        let query = FirebaseManager.shared.ref.child("streams/\(streamId!)/chat").queryLimited(toLast: 1)
        FirebaseManager.shared.observe(query: query, path: nil, event: .childAdded) { [weak self] response in
            switch response{
            
            case .success(let snapShot):
                
                guard let result = snapShot.value as? [String:Any] else{
                    return
                }
                
                
                let message = result["message"] as? String ?? ""
                let name = result["name"] as? String ?? ""
                let url = result["url"] as? String ?? ""
                let lastName = result["lastName"] as? String ?? ""
                
                self?.vc.messages.append(StreamMessage(message: message,name: name, lastName: lastName,url: url))
                DispatchQueue.main.async {
                    self?.vc.tableView.reloadData()
                    self?.vc.tableView.scrollTableViewToBottom(animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    
    
    
    
    func fetchReaction(){
        
//        FirebaseManager.shared.observeReaction(id: streamId) {[weak self] animationType in
//            self?.vc.generateAnimation(type: animationType)
//            self?.vc.generateAnimation(type: .person)
//
//        }
        let query = FirebaseManager.shared.ref.child("streams/\(streamId!)/reactions").queryLimited(toLast: 1)
        FirebaseManager.shared.observe(query: query, path: nil, event: .childAdded) { [weak self] response in
            
            switch response{
            case .success(let snapShot):
                
                guard let result = snapShot.value as? [String:String],
                    let animationImage = result["type"],
                    let type = AnimationImage(rawValue: animationImage) else{
                    print("&&fail to get reaction snapshot.value")
                    return
                }
                let imageUrl = result["url"] ?? ""
                let userName = result["firstname"] ?? ""
                self?.vc.generateAnimation(type: type,url: imageUrl, userName: userName)
                self?.vc.generateAnimation(type: .person,url: imageUrl, userName: userName)

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func ClearParticipents(){
        FirebaseManager.shared.ref.child("\(basePath)/participents").removeValue()
    }

    func observeParticipents(){
        
        let path : DatabaseReference = FirebaseManager.shared.ref.child("\(basePath)/participents")
        FirebaseManager.shared.observe(query: nil, path: path, event: .value) { [weak self] response in
            
            switch response{
            case .success(let snapShot):
                print("oberver participents callback come and ",snapShot.childrenCount)
                self?.streamParticipents = []
                Cashe.streamParticipents = []
                print("stream participents is after clear",self?.streamParticipents)
                print("snapshot is",snapShot)
                
                if snapShot.exists(){
                    
                    for child in snapShot.children{
                        
                        
                        
                        guard
                            let snap = child as? DataSnapshot,
                            let data = snap.value as? [String:String] else{
                                print("return from fetch data from ")
                                return
                            }
                        print(snap.key)
                        print(snap.value)
                        
                        let id = snap.key
                        let name = data["name"] ?? ""
                        let image = data["image"] ?? ""
                        let userId = data["userId"] ?? ""
                        self?.streamParticipents.append(StreamParticipent(id: id, name: name, image: image, userId: userId))
                    }
                    
                    self?.vc.txtViewers.text = String(self?.streamParticipents.count ?? 0)
                    Cashe.streamParticipents = self!.streamParticipents
                }
                
                
            case .failure(let error):
                self?.streamParticipents = []
                Cashe.streamParticipents = []
                self?.vc.txtViewers.text = "0"
                print(error.localizedDescription)
            }
        }
    }
    
    func rect(type : String){
        
        FirebaseManager.shared.updateReaction(id: streamId,type: type)
    }
    
    
    
    
    
}

// MARK:- Backend Api
extension BroadcasterViewModel{
    
    
    
    
    func startEvent(_ id : Int){
        print("start event id is",id)
        guard let url = Methods.shared.stringToUrl(APIEndPoints.startEvent) else{
            return
        }
        let apiService = APIManager(headerType: .backend, parameters: ["event_id":id], url: url)
        apiService.post { [weak self] response in
            switch response{
            case .success(let json):
                print("json is",json)
                guard let json = json["data"] as? [String:Any],
                      let token = json["agora_token"] as? String,
                      let channelId = json["id"] as? Int else {
                          print("Fail to get the token and cahnnel name")
                          return
                      }
                print("channel and token is",token,String(channelId))
                KeyCenter.channelName = String(channelId)
                KeyCenter.token = token
                KeyCenter.AppId = "f5b328dc4dfe41c7bfbe5e216b7c515e"
                self?.vc.setupStream()
                self?.setupFirebase()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getAgoraCredentials(){
        
        let url = URL(string: "https://conneqt.senarios.co/api/get/agora/auth")!
        let object = APIManager(headerType: .none, url: url)
        object.getJSON { [weak self] result in
            switch result{
            case .success(let json):
                guard let data = json["data"] as? [String:Any],
                      let appId = data["app_id"] as? String,
                      let token = data["token"] as? String,
                      let channelName = data["channel_id"] as? String else{
                          return
                      }
                print("Agora Credentials are",appId,token,channelName)
              //  KeyCenter.AppId = // appId
               // KeyCenter.token = token
              //  KeyCenter.channelName = channelName
               
            
            case .failure(let error):
                print("comein get agora token eerror",error)
            }
        }
    }
    
    
    func endEvent(_ id : Int){
        guard let url = Methods.shared.stringToUrl(APIEndPoints.endEvent) else{
            return
        }
        print("End event id is",id)
        let apiService = APIManager(headerType: .backend, parameters: ["event_id":id], url: url)
        apiService.post { [weak self] response in
            switch response{
            case .success(let json):
                print("end event json is json is",json)
                self?.ClearParticipents()
                NotificationCenter.default.post(name: NotificationName.RELOAD_EVENT, object: nil)
                
            case .failure(let error):
                print("come in stream end error")
                self?.vc.navigationController?.popViewController(animated: true)
                print(error.localizedDescription)
            }
        }
    }


}
