//
//  FirebaseManager.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 29/11/2021.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit
import CoreMedia

class FirebaseManager{
    
    static let shared = FirebaseManager()
    let ref = Database.database(url: "https://connectqi-a5ad1-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    private init(){}
    

    
    
    
    
    func Add(path : DatabaseReference,value : [String : Any],onCompletion : @escaping(Result<Bool,Error>) -> Void){
        
        path.setValue(value){ error,_ in
            if error != nil{
                onCompletion(.failure(FirebaseError.dataNotAddInDb))
                return
            }
            onCompletion(.success(true))
        }
    }
    
    
    func get(path : DatabaseReference,onCompletion : @escaping(Result<DataSnapshot,Error>) -> Void){
       
        
        path.observeSingleEvent(of: .value) { snapShot in
            if snapShot.exists(){
                print("come in data exist")
                onCompletion(.success(snapShot))
                return
            }
            print("come in oncompletion failure")
            onCompletion(.failure(FirebaseError.noDataFound))
            
            
        }

    }
    
    func observe(query : DatabaseQuery?,path : DatabaseReference?,event : DataEventType, onCompletion : @escaping(Result<DataSnapshot,Error>) -> Void){
        print("observe function call")
        let call = query == nil ? path:query
         call?.observe(event){ data in
            if data.exists(){
                print("come in data exist")
                onCompletion(.success(data))
                return
            }else{
                print("data not exist")
            }
            print("come in oncompletion failure")
            onCompletion(.failure(FirebaseError.noDataFound))
        }
    }
    
    
    func update(path : DatabaseReference,value : [String : Any],onCompletion : @escaping(Result<Bool,Error>) -> Void){
        
        path.updateChildValues(value) { error, _ in
            
            if error == nil{
                onCompletion(.success(true))
                return
            }
            onCompletion(.failure(FirebaseError.notUpdated))
        }
    }
    
    
    func delete(path : DatabaseReference,onCompletion : @escaping (Bool) -> Void){
        path.removeValue { error, _ in
            if error != nil{
                onCompletion(false)
                return
            }
            onCompletion(true)
        }
    }
    
    
    

    
    
    func createFirebaseStream(streamId : String){
        
        let data : [String:Any] = [
            "video":VideoStatus.enable.rawValue,
            "audio":AudioStatus.unmute.rawValue
         ]
        print("stream id before create in firebae",streamId)
        ref.child("streams/\(streamId)").child("status").setValue(data) { error, _ in
            if error != nil{
                print("stream not created in firebase")
                return
            }
            print("stream successfully created in firebase")
        }
    }
    
    
    func observeViewers(id streamId : String, onCompletion : @escaping (Int) -> Void){
        
        ref.child("streams/\(streamId)/status").child("view").observe(.value) { snapShot in
            print("fetchNumberOfViewers result",snapShot.value)
            guard let count = snapShot.value as? Int else{
                print("fail to fetchNumberOfViewers")
                return
            }
            onCompletion(count)
        } withCancel: { error in
            print("error come",error.localizedDescription)
        }

    }
    
    func observeReaction(id streamId : String, onCompletion : @escaping (AnimationImage,String) -> Void){
        print("&&observer reaction function call")
        ref.child("streams/\(streamId)/reactions").queryLimited(toLast: 1).observe(.childAdded) { snapShot in
            print("&& observer reaction snapshot.value",snapShot.value)
            
            guard let result = snapShot.value as? [String:String],
                let animationImage = result["type"],
                let type = AnimationImage(rawValue: animationImage) else{
                print("&&fail to get reaction snapshot.value")
                return
            }
            let userUrl = result["url"]
            switch type {
            case .person:
                onCompletion(.person,userUrl ?? "")
            case .heart:
                onCompletion(.heart,userUrl ?? "")
            case .thumb:
                onCompletion(.thumb,userUrl ?? "")
            }
        
            

        }
        
    }
    
    
    func updateReaction(id streamId : String,type : String){
        print("update reaction function call")
        let data = ["type":type]
        ref.child("streams/\(streamId)/reactions").childByAutoId().setValue(data){ error, response in

            if error != nil{
                print("successfully update the reaction in db")
                return
            }
            print("error come ",error?.localizedDescription)
            
        }
    }
    
    func updateBlockParticipents(streamId : String,userId : String){
        print("update reaction function call")
        let data = ["userId":userId]
        ref.child("streams/\(streamId)/blockUsers").childByAutoId().setValue(data){ error, response in

            if error != nil{
                print("successfully update the reaction in db")
                return
            }
            print("error come ",error?.localizedDescription)
            
        }
    }
    
    
    func updateVideoStatus(id streamId : String, status : VideoStatus){
        
        ref.child("streams/\(streamId)/status").updateChildValues(["video":status.rawValue]) { error, _ in
            if error == nil{
                print("video status update successfully")
            }
        }
    }
    
    func updateAudioStatus(id streamId : String, status : AudioStatus){
        
        ref.child("streams/\(streamId)/status").updateChildValues(["audio":status.rawValue]) { error, _ in
            if error == nil{
                print("audio status update successfully")
            }
        }
    }
    
    
    
  
    
    func sendMessage(streamId : String ,message : String ){
        
        let result = ["message":message]
        ref.child("streams/\(streamId)").child("chat").childByAutoId().setValue(result) { error, _ in
            
            
            if error != nil{
                print("fail to store data",error?.localizedDescription)
                
                return
            }
            print("save data successfully")
        }
        
    }
    
    
    func fetchRealTimeChat(streamId : String,onCompletion : @escaping (Result<StreamMessage,Error>) -> Void ){
        ref.child("streams/\(streamId)/chat").queryLimited(toLast: 1).observe(.childAdded) { snapShot in
            print("snapshot is childAdded",snapShot.value)
            
            if snapShot.exists(){
              
                guard let result = snapShot.value as? [String:Any] else{
                    return
                }
                print("snapshot value is",result)
                let message = result["message"] as? String ?? ""
                let name = result["name"] as? String ?? ""
                let lastName = result["lastName"] as? String ?? ""
                let url = result["url"] as? String ?? ""
               
                onCompletion(.success(StreamMessage(message: message,name: name, lastName: lastName, url: url)))

            }else{

                onCompletion(.failure(FirebaseError.noDataFound))
            }
           
            
        } withCancel: { error in
            
            print(error.localizedDescription)
            onCompletion(.failure(FirebaseError.somethingWentWrong))
        }
        
        

    }
    
}

enum FirebaseError : Error{
    case noDataFound
    case somethingWentWrong
    case dataNotAddInDb
    case notUpdated
}



