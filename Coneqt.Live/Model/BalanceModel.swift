//
//  BalanceModel.swift
//  Coneqt.Live
//
//  Created by Senarios on 14/02/2022.
//

import Foundation


struct BalanceModel : Codable{
    
    let success : Bool
    let available : Double
    let pending : Double
    let events : Int
    let revenue : Double
    let ticket : Int
    let refund : Double
}


struct PayoutModel : Codable{
    
    let success : Bool
    let message: String
    
}

struct PreferencesModel : Codable{
    
    let success : Bool
    let message: String
    
}

struct FilterBalanceModel : Codable{
    
    
    let success : Bool
    let message: String
    let total_events : Int
    let revenue: Double
    let tickets: Int
    let refunds: Double
    
}



struct ConnectAccountStatus : Codable{
    
    let success : Bool
    let id : String
    let message : String
}


