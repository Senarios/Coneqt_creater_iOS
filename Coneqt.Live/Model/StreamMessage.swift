//
//  StreamMessage.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 29/11/2021.
//

import Foundation


struct StreamParticipent {
    
    let id : String
    let name : String
    let image : String
    let userId : String
}


struct StreamMessage : Codable{
    
    let message : String
    let name : String
    let lastName: String
    let url : String
}


struct GenerelResponse : Codable{
    
    let success : Bool
    let message : String
    
}

struct NotificationCountResponse : Codable{
    
    let success : Bool
    let count : Int
    
}
