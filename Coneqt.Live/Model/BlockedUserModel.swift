//
//  BlockedUserModel.swift
//  Coneqt.Live
//
//  Created by Azhar on 3/30/22.
//

import Foundation


struct BlockedUserModel : Codable {
    let success : Bool?
    let message : String?
    let blockUsers : [BlockUserItem]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case blockUsers = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        blockUsers = try values.decodeIfPresent([BlockUserItem].self, forKey: .blockUsers)
    }

}

struct BlockUserItem : Codable {
    let id : Int?
    let content_creator_id : Int?
    let content_viewer_id : Int?
    let name : String?
    let image_url : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case content_creator_id = "content_creator_id"
        case content_viewer_id = "content_viewer_id"
        case name = "name"
        case image_url = "image_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        content_creator_id = try values.decodeIfPresent(Int.self, forKey: .content_creator_id)
        content_viewer_id = try values.decodeIfPresent(Int.self, forKey: .content_viewer_id)
    }

}
