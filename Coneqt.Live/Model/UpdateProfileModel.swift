//
//  UpdateProfileModel.swift
//  Coneqt.Live
//
//  Created by Senarios on 15/02/2022.
//

import Foundation

struct UpdateProfileModel : Codable {
    
    let success : Bool
    let message : String?
    let profile : Profile?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case profile = "data"
    }
  
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        profile = try values.decodeIfPresent(Profile.self, forKey: .profile)
    }
}



struct Profile : Codable {
    let id : Int?
    let first_name : String?
    let last_name : String?
    let email : String?
    let email_verified_at : String?
    let phone : String?
    let verification_code : Int?
    let image_url : String?
    let image_url1 : String?
    let stripe_account_id : String?
    let stripe_customer_id : String?
    let type : String?
    let api_token : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
        case email_verified_at = "email_verified_at"
        case phone = "phone"
        case verification_code = "verification_code"
        case image_url = "image_url"
        case image_url1 = "image_url1"
        case stripe_account_id = "stripe_account_id"
        case stripe_customer_id = "stripe_customer_id"
        case type = "type"
        case api_token = "api_token"
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
        verification_code = try values.decodeIfPresent(Int  .self, forKey: .verification_code)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        image_url1 = try values.decodeIfPresent(String.self, forKey: .image_url1)
        stripe_account_id = try values.decodeIfPresent(String.self, forKey: .stripe_account_id)
        stripe_customer_id = try values.decodeIfPresent(String.self, forKey: .stripe_customer_id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        api_token = try values.decodeIfPresent(String.self, forKey: .api_token)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}

