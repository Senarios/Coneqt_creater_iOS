//
//  EventModel.swift
//  Coneqt.Live
//
//  Created by Senarios on 01/02/2022.
//

import Foundation




struct EventModel : Codable {
    let success : Bool?
    let message : String?
    let event : Event?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case event = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        event = try values.decodeIfPresent(Event.self, forKey: .event)
    }

}


struct Event : Codable {
    let name : String?
    let description : String?
    let time : String?
    let time_duration : String?
    let type : String?
    let ticket_price : String?
    let stream_interaction : String?
    let status : String?
    let content_creator_id : Int?
    let updated_at : String?
    let created_at : String?
    let id : Int?
    let content_creator : Content_creator?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case description = "description"
        case time = "time"
        case time_duration = "time_duration"
        case type = "type"
        case ticket_price = "ticket_price"
        case stream_interaction = "stream_interaction"
        case status = "status"
        case content_creator_id = "content_creator_id"
        case updated_at = "updated_at"
        case created_at = "created_at"
        case id = "id"
        case content_creator = "content_creator"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        time_duration = try values.decodeIfPresent(String.self, forKey: .time_duration)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        ticket_price = try values.decodeIfPresent(String.self, forKey: .ticket_price)
        stream_interaction = try values.decodeIfPresent(String.self, forKey: .stream_interaction)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        content_creator_id = try values.decodeIfPresent(Int.self, forKey: .content_creator_id)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        content_creator = try values.decodeIfPresent(Content_creator.self, forKey: .content_creator)
    }

}



struct Content_creator : Codable {
    let id : Int?
    let first_name : String?
    let last_name : String?
    let email : String?
    let auth_type : String?
    let social_id : String?
    let email_verified_at : String?
    let phone : String?
    let verification_code : String?
    let image_url : String?
    let stripe_account_id : String?
    let stripe_payout : Int?
    let api_token : String?
    let social_image_url : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
        case auth_type = "auth_type"
        case social_id = "social_id"
        case email_verified_at = "email_verified_at"
        case phone = "phone"
        case verification_code = "verification_code"
        case image_url = "image_url"
        case stripe_account_id = "stripe_account_id"
        case stripe_payout = "stripe_payout"
        case api_token = "api_token"
        case social_image_url = "social_image_url"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        auth_type = try values.decodeIfPresent(String.self, forKey: .auth_type)
        social_id = try values.decodeIfPresent(String.self, forKey: .social_id)
        email_verified_at = try values.decodeIfPresent(String.self, forKey: .email_verified_at)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        verification_code = try values.decodeIfPresent(String.self, forKey: .verification_code)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        stripe_account_id = try values.decodeIfPresent(String.self, forKey: .stripe_account_id)
        stripe_payout = try values.decodeIfPresent(Int.self, forKey: .stripe_payout)
        api_token = try values.decodeIfPresent(String.self, forKey: .api_token)
        social_image_url = try values.decodeIfPresent(String.self, forKey: .social_image_url)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
