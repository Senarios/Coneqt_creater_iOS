//
//  FilterModel.swift
//  Coneqt.Live
//
//  Created by Senarios on 09/03/2022.
//

import Foundation


struct FilterModel : Codable {
    let success : Bool?
    let message : String?
    let filters : [FilterItem]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case filters = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        filters = try values.decodeIfPresent([FilterItem].self, forKey: .filters)
    }

}

struct FilterItem : Codable {
    let id : Int?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}


