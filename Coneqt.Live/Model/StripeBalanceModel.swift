//
//  StripeBalanceModel.swift
//  Coneqt.Live
//
//  Created by Senarios on 10/02/2022.
//

import Foundation

struct StripeBalanceModel : Codable {
    let object : String?
    let available : [Available]?
    let livemode : Bool?
    let pending : [Pending]?

    enum CodingKeys: String, CodingKey {

        case object = "object"
        case available = "available"
        case livemode = "livemode"
        case pending = "pending"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        object = try values.decodeIfPresent(String.self, forKey: .object)
        available = try values.decodeIfPresent([Available].self, forKey: .available)
        livemode = try values.decodeIfPresent(Bool.self, forKey: .livemode)
        pending = try values.decodeIfPresent([Pending].self, forKey: .pending)
    }

}



import Foundation
struct Pending : Codable {
    let amount : Int?
    let currency : String?
    let source_types : Source_types?

    enum CodingKeys: String, CodingKey {

        case amount = "amount"
        case currency = "currency"
        case source_types = "source_types"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        source_types = try values.decodeIfPresent(Source_types.self, forKey: .source_types)
    }

}



struct Available : Codable {
    let amount : Int?
    let currency : String?
    let source_types : Source_types?

    enum CodingKeys: String, CodingKey {

        case amount = "amount"
        case currency = "currency"
        case source_types = "source_types"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        source_types = try values.decodeIfPresent(Source_types.self, forKey: .source_types)
    }

}



struct Source_types : Codable {
    let card : Int?

    enum CodingKeys: String, CodingKey {

        case card = "card"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        card = try values.decodeIfPresent(Int.self, forKey: .card)
    }

}
