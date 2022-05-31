//
//  User.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 17/12/2021.
//

import Foundation

struct LoginModel : Codable {
    
    let success : Bool?
    let message : String?
    let user : AppUser?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case user = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        user = try values.decodeIfPresent(AppUser.self, forKey: .user)
    }


}


struct AppUser : Codable {
    let id : Int?
    let first_name : String?
    let last_name : String?
    let email : String?
    let email_verified_at : String?
    let phone : String?
    let image_url : String?
    let stripe_account_id : String?
    let token : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
        case email_verified_at = "email_verified_at"
        case phone = "phone"
        case image_url = "image_url"
        case stripe_account_id = "stripe_account_id"
        case token = "token"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        email_verified_at = try values.decodeIfPresent(String.self, forKey: .email_verified_at)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        stripe_account_id = try values.decodeIfPresent(String.self, forKey: .stripe_account_id)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
