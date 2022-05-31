//
//  NotificationModel.swift
//  Coneqt.Live
//
//  Created by Senarios on 08/03/2022.
//

import Foundation
struct NotificationModel : Codable {
    let success : Bool?
    let message : String?
    let notification : Notifications?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case notification = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        notification = try values.decodeIfPresent(Notifications.self, forKey: .notification)
    }

}

struct Notifications : Codable {
    
    let today : [Today]?
    let earlier : [Earlier]?

    enum CodingKeys: String, CodingKey {

        case today = "today"
        case earlier = "earlier"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        today = try values.decodeIfPresent([Today].self, forKey: .today)
        earlier = try values.decodeIfPresent([Earlier].self, forKey: .earlier)
    }

}



struct Earlier : Codable {
    let id : Int?
    let content_creator_id : Int?
    let content_viewer_id : String?
    let event_id : Int?
    let title : String?
    let body : String?
    let status : Int?
    let type : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case content_creator_id = "content_creator_id"
        case content_viewer_id = "content_viewer_id"
        case event_id = "event_id"
        case title = "title"
        case body = "body"
        case status = "status"
        case type = "type"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        content_creator_id = try values.decodeIfPresent(Int.self, forKey: .content_creator_id)
        content_viewer_id = try values.decodeIfPresent(String.self, forKey: .content_viewer_id)
        event_id = try values.decodeIfPresent(Int.self, forKey: .event_id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}


struct Today : Codable {
    let id : Int?
    let content_creator_id : Int?
    let content_viewer_id : String?
    let event_id : Int?
    let title : String?
    let body : String?
    let status : Int?
    let type : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case content_creator_id = "content_creator_id"
        case content_viewer_id = "content_viewer_id"
        case event_id = "event_id"
        case title = "title"
        case body = "body"
        case status = "status"
        case type = "type"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        content_creator_id = try values.decodeIfPresent(Int.self, forKey: .content_creator_id)
        content_viewer_id = try values.decodeIfPresent(String.self, forKey: .content_viewer_id)
        event_id = try values.decodeIfPresent(Int.self, forKey: .event_id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
