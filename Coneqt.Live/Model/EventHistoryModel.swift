//
//  EventHistoryModel.swift
//  Coneqt.Live
//
//  Created by Senarios on 02/02/2022.
//

import Foundation


struct EventHistoryModel : Codable {
    let success : Bool?
    let message : String?
    let eventHistory : EventHistory?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case eventHistory = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        eventHistory = try values.decodeIfPresent(EventHistory.self, forKey: .eventHistory)
    }

}


struct EventHistory : Codable {
    let upcoming : [Upcoming]?
    let past : [Past]?

    enum CodingKeys: String, CodingKey {

        case upcoming = "upcoming"
        case past = "past"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        upcoming = try values.decodeIfPresent([Upcoming].self, forKey: .upcoming)
        past = try values.decodeIfPresent([Past].self, forKey: .past)
    }

}

struct Past : Codable {
    let id : Int?
    let name : String?
    let content_creator_id : Int?
    let time : String?
    let time_duration : Int?
    let description : String?
    let type : String?
    let ticket_price : Int?
    let stream_interaction : Int?
    let status : String?
    let agora_token : String?
    let avg_rating : Double?
    let rates_count : Int?
    let image1 : String?
    let image2 : String?
    let image3 : String?
    let image1_s3 : String?
    let image2_s3 : String?
    let image3_s3 : String?
    let created_at : String?
    let updated_at : String?
    let totalTicketPurchased : Int?
    let totalEventRevenue : Double?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case content_creator_id = "content_creator_id"
        case time = "time"
        case time_duration = "time_duration"
        case description = "description"
        case type = "type"
        case ticket_price = "ticket_price"
        case stream_interaction = "stream_interaction"
        case status = "status"
        case agora_token = "agora_token"
        case avg_rating = "avg_rating"
        case rates_count = "rates_count"
        case image1 = "image1"
        case image2 = "image2"
        case image3 = "image3"
        case image1_s3 = "image1_s3"
        case image2_s3 = "image2_s3"
        case image3_s3 = "image3_s3"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case totalTicketPurchased = "totalTicketPurchased"
        case totalEventRevenue = "totalEventRevenue"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        content_creator_id = try values.decodeIfPresent(Int.self, forKey: .content_creator_id)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        time_duration = try values.decodeIfPresent(Int.self, forKey: .time_duration)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        ticket_price = try values.decodeIfPresent(Int.self, forKey: .ticket_price)
        stream_interaction = try values.decodeIfPresent(Int.self, forKey: .stream_interaction)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        agora_token = try values.decodeIfPresent(String.self, forKey: .agora_token)
        avg_rating = try values.decodeIfPresent(Double.self, forKey: .avg_rating)
        rates_count = try values.decodeIfPresent(Int.self, forKey: .rates_count)
        image1 = try values.decodeIfPresent(String.self, forKey: .image1)
        image2 = try values.decodeIfPresent(String.self, forKey: .image2)
        image3 = try values.decodeIfPresent(String.self, forKey: .image3)
        image1_s3 = try values.decodeIfPresent(String.self, forKey: .image1_s3)
        image2_s3 = try values.decodeIfPresent(String.self, forKey: .image2_s3)
        image3_s3 = try values.decodeIfPresent(String.self, forKey: .image3_s3)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        totalTicketPurchased = try values.decodeIfPresent(Int.self, forKey: .totalTicketPurchased)
        totalEventRevenue = try values.decodeIfPresent(Double.self, forKey: .totalEventRevenue)
    }

}

/*
struct LinkData : Codable {
    let toShow : String?
    let toOpen : String?

    enum CodingKeys: String, CodingKey {

        case toShow = "toShow"
        case toOpen = "toOpen"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        toShow = try values.decodeIfPresent(String.self, forKey: .toShow)
        toOpen = try values.decodeIfPresent(String.self, forKey: .toOpen)
    }

}
*/

//struct Upcoming : Codable {
//    let id : Int?
//    let name : String?
//    let content_creator_id : Int?
//    let time : String?
//    let time_duration : String?
//    let description : String?
//    let type : String?
//    let ticket_price : Int?
//    let stream_interaction : Int?
//    let status : String?
//    let agora_token : String?
//    let image1 : String?
//    let image2 : String?
//    let image3 : String?
//    let image1_s3 : String?
//    let image2_s3 : String?
//    let image3_s3 : String?
//    let created_at : String?
//    let updated_at : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case name = "name"
//        case content_creator_id = "content_creator_id"
//        case time = "time"
//        case time_duration = "time_duration"
//        case description = "description"
//        case type = "type"
//        case ticket_price = "ticket_price"
//        case stream_interaction = "stream_interaction"
//        case status = "status"
//        case agora_token = "agora_token"
//        case image1 = "image1"
//        case image2 = "image2"
//        case image3 = "image3"
//        case image1_s3 = "image1_s3"
//        case image2_s3 = "image2_s3"
//        case image3_s3 = "image3_s3"
//        case created_at = "created_at"
//        case updated_at = "updated_at"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        content_creator_id = try values.decodeIfPresent(Int.self, forKey: .content_creator_id)
//        time = try values.decodeIfPresent(String.self, forKey: .time)
//        time_duration = try values.decodeIfPresent(String.self, forKey: .time_duration)
//        description = try values.decodeIfPresent(String.self, forKey: .description)
//        type = try values.decodeIfPresent(String.self, forKey: .type)
//        ticket_price = try values.decodeIfPresent(Int.self, forKey: .ticket_price)
//        stream_interaction = try values.decodeIfPresent(Int.self, forKey: .stream_interaction)
//        status = try values.decodeIfPresent(String.self, forKey: .status)
//        agora_token = try values.decodeIfPresent(String.self, forKey: .agora_token)
//        image1 = try values.decodeIfPresent(String.self, forKey: .image1)
//        image2 = try values.decodeIfPresent(String.self, forKey: .image2)
//        image3 = try values.decodeIfPresent(String.self, forKey: .image3)
//        image1_s3 = try values.decodeIfPresent(String.self, forKey: .image1_s3)
//        image2_s3 = try values.decodeIfPresent(String.self, forKey: .image2_s3)
//        image3_s3 = try values.decodeIfPresent(String.self, forKey: .image3_s3)
//        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
//    }
//
//}


//struct Upcoming : Codable {
//    let id : Int?
//    let name : String?
//    let content_creator_id : Int?
//    let time : String?
//    let time_duration : String?
//    let description : String?
//    let type : String?
//    let ticket_price : Int?
//    let stream_interaction : Int?
//    let status : String?
//    let agora_token : String?
//    let image1 : String?
//    let image2 : String?
//    let image3 : String?
//    let image1_s3 : String?
//    let image2_s3 : String?
//    let image3_s3 : String?
//    let created_at : String?
//    let updated_at : String?
//    let event_payments_and_verification_count : Int?
//    let event_payments_and_verification_sum_ticket_price : Int?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case name = "name"
//        case content_creator_id = "content_creator_id"
//        case time = "time"
//        case time_duration = "time_duration"
//        case description = "description"
//        case type = "type"
//        case ticket_price = "ticket_price"
//        case stream_interaction = "stream_interaction"
//        case status = "status"
//        case agora_token = "agora_token"
//        case image1 = "image1"
//        case image2 = "image2"
//        case image3 = "image3"
//        case image1_s3 = "image1_s3"
//        case image2_s3 = "image2_s3"
//        case image3_s3 = "image3_s3"
//        case created_at = "created_at"
//        case updated_at = "updated_at"
//        case event_payments_and_verification_count = "event_payments_and_verification_count"
//        case event_payments_and_verification_sum_ticket_price = "event_payments_and_verification_sum_ticket_price"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        content_creator_id = try values.decodeIfPresent(Int.self, forKey: .content_creator_id)
//        time = try values.decodeIfPresent(String.self, forKey: .time)
//        time_duration = try values.decodeIfPresent(String.self, forKey: .time_duration)
//        description = try values.decodeIfPresent(String.self, forKey: .description)
//        type = try values.decodeIfPresent(String.self, forKey: .type)
//        ticket_price = try values.decodeIfPresent(Int.self, forKey: .ticket_price)
//        stream_interaction = try values.decodeIfPresent(Int.self, forKey: .stream_interaction)
//        status = try values.decodeIfPresent(String.self, forKey: .status)
//        agora_token = try values.decodeIfPresent(String.self, forKey: .agora_token)
//        image1 = try values.decodeIfPresent(String.self, forKey: .image1)
//        image2 = try values.decodeIfPresent(String.self, forKey: .image2)
//        image3 = try values.decodeIfPresent(String.self, forKey: .image3)
//        image1_s3 = try values.decodeIfPresent(String.self, forKey: .image1_s3)
//        image2_s3 = try values.decodeIfPresent(String.self, forKey: .image2_s3)
//        image3_s3 = try values.decodeIfPresent(String.self, forKey: .image3_s3)
//        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
//        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
//        event_payments_and_verification_count = try values.decodeIfPresent(Int.self, forKey: .event_payments_and_verification_count)
//        event_payments_and_verification_sum_ticket_price = try values.decodeIfPresent(Int.self, forKey: .event_payments_and_verification_sum_ticket_price)
//    }
//
//}


