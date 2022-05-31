//
//  GetUserDataModel.swift
//  Coneqt.Live
//
//  Created by Azhar on 3/31/22.
//

import Foundation


struct GetUserDataModel : Codable {
    let success : Bool?
    let message : String?
    let userData : userItem?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case userData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        userData = try values.decodeIfPresent(userItem.self, forKey: .userData)
    }

}

struct userItem : Codable {
    let user : userItemData

    enum CodingKeys: String, CodingKey {

        case user = "user"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(userItemData.self, forKey: .user)!
    }

}

struct userItemData : Codable {
    let id : Int?
    let first_name : String?
    let last_name : String?
    let email : String?
    let phone : String?
    
    let image_url : String?
    let stripe_account_id : String?
    let social_image_url : String?
    let api_token : String?
    let device_notification : Int?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "name"
        case phone = "phone"
        case image_url = "image_url"
        case stripe_account_id = "stripe_account_id"
        case social_image_url = "social_image_url"
        case api_token = "api_token"
        case device_notification = "device_notification"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        stripe_account_id = try values.decodeIfPresent(String.self, forKey: .stripe_account_id)
        social_image_url = try values.decodeIfPresent(String.self, forKey: .social_image_url)
        api_token = try values.decodeIfPresent(String.self, forKey: .api_token)
        device_notification = try values.decodeIfPresent(Int.self, forKey: .device_notification)
    }

}
