//
//  UnblockUserModel.swift
//  Coneqt.Live
//
//  Created by Azhar on 3/30/22.
//

import Foundation

struct UnblockUserModel : Codable {
    let success : Bool?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
