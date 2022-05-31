//
//  ConnectedAccount.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 17/12/2021.
//

import Foundation

import Foundation
struct ConnectedAccountModel : Codable {
    let id : String?
    let object : String?
    let business_profile : Business_profile?
    let capabilities : Capabilities?
    let charges_enabled : Bool?
    let country : String?
    let created : Int?
    let default_currency : String?
    let details_submitted : Bool?
    let email : String?
    let external_accounts : External_accounts?
    let future_requirements : Future_requirements?
    let login_links : Login_links?
//    let metadata : Metadata?
    let payouts_enabled : Bool?
    let requirements : Requirements?
    let settings : Settings?
    let tos_acceptance : Tos_acceptance?
    let type : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case object = "object"
        case business_profile = "business_profile"
        case capabilities = "capabilities"
        case charges_enabled = "charges_enabled"
        case country = "country"
        case created = "created"
        case default_currency = "default_currency"
        case details_submitted = "details_submitted"
        case email = "email"
        case external_accounts = "external_accounts"
        case future_requirements = "future_requirements"
        case login_links = "login_links"
//        case metadata = "metadata"
        case payouts_enabled = "payouts_enabled"
        case requirements = "requirements"
        case settings = "settings"
        case tos_acceptance = "tos_acceptance"
        case type = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        object = try values.decodeIfPresent(String.self, forKey: .object)
        business_profile = try values.decodeIfPresent(Business_profile.self, forKey: .business_profile)
        capabilities = try values.decodeIfPresent(Capabilities.self, forKey: .capabilities)
        charges_enabled = try values.decodeIfPresent(Bool.self, forKey: .charges_enabled)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        created = try values.decodeIfPresent(Int.self, forKey: .created)
        default_currency = try values.decodeIfPresent(String.self, forKey: .default_currency)
        details_submitted = try values.decodeIfPresent(Bool.self, forKey: .details_submitted)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        external_accounts = try values.decodeIfPresent(External_accounts.self, forKey: .external_accounts)
        future_requirements = try values.decodeIfPresent(Future_requirements.self, forKey: .future_requirements)
        login_links = try values.decodeIfPresent(Login_links.self, forKey: .login_links)
//        metadata = try values.decodeIfPresent(Metadata.self, forKey: .metadata)
        payouts_enabled = try values.decodeIfPresent(Bool.self, forKey: .payouts_enabled)
        requirements = try values.decodeIfPresent(Requirements.self, forKey: .requirements)
        settings = try values.decodeIfPresent(Settings.self, forKey: .settings)
        tos_acceptance = try values.decodeIfPresent(Tos_acceptance.self, forKey: .tos_acceptance)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }

}

struct Branding : Codable {
    let icon : String?
    let logo : String?
    let primary_color : String?
    let secondary_color : String?

    enum CodingKeys: String, CodingKey {

        case icon = "icon"
        case logo = "logo"
        case primary_color = "primary_color"
        case secondary_color = "secondary_color"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        primary_color = try values.decodeIfPresent(String.self, forKey: .primary_color)
        secondary_color = try values.decodeIfPresent(String.self, forKey: .secondary_color)
    }

}

struct Business_profile : Codable {
    let mcc : String?
    let name : String?
    let support_address : String?
    let support_email : String?
    let support_phone : String?
    let support_url : String?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case mcc = "mcc"
        case name = "name"
        case support_address = "support_address"
        case support_email = "support_email"
        case support_phone = "support_phone"
        case support_url = "support_url"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mcc = try values.decodeIfPresent(String.self, forKey: .mcc)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        support_address = try values.decodeIfPresent(String.self, forKey: .support_address)
        support_email = try values.decodeIfPresent(String.self, forKey: .support_email)
        support_phone = try values.decodeIfPresent(String.self, forKey: .support_phone)
        support_url = try values.decodeIfPresent(String.self, forKey: .support_url)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

struct Capabilities : Codable {
    let card_payments : String?
    let transfers : String?

    enum CodingKeys: String, CodingKey {

        case card_payments = "card_payments"
        case transfers = "transfers"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        card_payments = try values.decodeIfPresent(String.self, forKey: .card_payments)
        transfers = try values.decodeIfPresent(String.self, forKey: .transfers)
    }

}


struct Card_issuing : Codable {
    let tos_acceptance : Tos_acceptance?

    enum CodingKeys: String, CodingKey {

        case tos_acceptance = "tos_acceptance"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tos_acceptance = try values.decodeIfPresent(Tos_acceptance.self, forKey: .tos_acceptance)
    }

}



struct Card_payments : Codable {
    let decline_on : Decline_on?
    let statement_descriptor_prefix : String?

    enum CodingKeys: String, CodingKey {

        case decline_on = "decline_on"
        case statement_descriptor_prefix = "statement_descriptor_prefix"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        decline_on = try values.decodeIfPresent(Decline_on.self, forKey: .decline_on)
        statement_descriptor_prefix = try values.decodeIfPresent(String.self, forKey: .statement_descriptor_prefix)
    }

}


struct Dashboard : Codable {
    let display_name : String?
    let timezone : String?

    enum CodingKeys: String, CodingKey {

        case display_name = "display_name"
        case timezone = "timezone"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        display_name = try values.decodeIfPresent(String.self, forKey: .display_name)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
    }

}


struct Decline_on : Codable {
    let avs_failure : Bool?
    let cvc_failure : Bool?

    enum CodingKeys: String, CodingKey {

        case avs_failure = "avs_failure"
        case cvc_failure = "cvc_failure"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        avs_failure = try values.decodeIfPresent(Bool.self, forKey: .avs_failure)
        cvc_failure = try values.decodeIfPresent(Bool.self, forKey: .cvc_failure)
    }

}


struct External_accounts : Codable {
    let object : String?
    let data : [External_accounts_Data]?
    let has_more : Bool?
    let total_count : Int?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case object = "object"
        case data = "data"
        case has_more = "has_more"
        case total_count = "total_count"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        object = try values.decodeIfPresent(String.self, forKey: .object)
        data = try values.decodeIfPresent([External_accounts_Data].self, forKey: .data)
        has_more = try values.decodeIfPresent(Bool.self, forKey: .has_more)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}


struct External_accounts_Data : Codable {
    let id : String?
    let object : String?
    let account : String?
    let account_holder_name : String?
    let account_holder_type : String?
    let account_type : String?
    let available_payout_methods : [String]?
    let bank_name : String?
    let country : String?
    let currency : String?
    let default_for_currency : Bool?
    let fingerprint : String?
    let last4 : String?
//    let metadata : Metadata?
    let routing_number : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case object = "object"
        case account = "account"
        case account_holder_name = "account_holder_name"
        case account_holder_type = "account_holder_type"
        case account_type = "account_type"
        case available_payout_methods = "available_payout_methods"
        case bank_name = "bank_name"
        case country = "country"
        case currency = "currency"
        case default_for_currency = "default_for_currency"
        case fingerprint = "fingerprint"
        case last4 = "last4"
//        case metadata = "metadata"
        case routing_number = "routing_number"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        object = try values.decodeIfPresent(String.self, forKey: .object)
        account = try values.decodeIfPresent(String.self, forKey: .account)
        account_holder_name = try values.decodeIfPresent(String.self, forKey: .account_holder_name)
        account_holder_type = try values.decodeIfPresent(String.self, forKey: .account_holder_type)
        account_type = try values.decodeIfPresent(String.self, forKey: .account_type)
        available_payout_methods = try values.decodeIfPresent([String].self, forKey: .available_payout_methods)
        bank_name = try values.decodeIfPresent(String.self, forKey: .bank_name)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        default_for_currency = try values.decodeIfPresent(Bool.self, forKey: .default_for_currency)
        fingerprint = try values.decodeIfPresent(String.self, forKey: .fingerprint)
        last4 = try values.decodeIfPresent(String.self, forKey: .last4)
//        metadata = try values.decodeIfPresent(Metadata.self, forKey: .metadata)
        routing_number = try values.decodeIfPresent(String.self, forKey: .routing_number)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}


struct Future_requirements : Codable {
    let alternatives : [String]?
    let current_deadline : String?
    let currently_due : [String]?
    let disabled_reason : String?
    let errors : [String]?
    let eventually_due : [String]?
    let past_due : [String]?
    let pending_verification : [String]?

    enum CodingKeys: String, CodingKey {

        case alternatives = "alternatives"
        case current_deadline = "current_deadline"
        case currently_due = "currently_due"
        case disabled_reason = "disabled_reason"
        case errors = "errors"
        case eventually_due = "eventually_due"
        case past_due = "past_due"
        case pending_verification = "pending_verification"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        alternatives = try values.decodeIfPresent([String].self, forKey: .alternatives)
        current_deadline = try values.decodeIfPresent(String.self, forKey: .current_deadline)
        currently_due = try values.decodeIfPresent([String].self, forKey: .currently_due)
        disabled_reason = try values.decodeIfPresent(String.self, forKey: .disabled_reason)
        errors = try values.decodeIfPresent([String].self, forKey: .errors)
        eventually_due = try values.decodeIfPresent([String].self, forKey: .eventually_due)
        past_due = try values.decodeIfPresent([String].self, forKey: .past_due)
        pending_verification = try values.decodeIfPresent([String].self, forKey: .pending_verification)
    }

}


struct Login_links : Codable {
    let object : String?
    let total_count : Int?
    let has_more : Bool?
    let url : String?
    let data : [String]?

    enum CodingKeys: String, CodingKey {

        case object = "object"
        case total_count = "total_count"
        case has_more = "has_more"
        case url = "url"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        object = try values.decodeIfPresent(String.self, forKey: .object)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
        has_more = try values.decodeIfPresent(Bool.self, forKey: .has_more)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        data = try values.decodeIfPresent([String].self, forKey: .data)
    }

}

//struct Metadata : Codable {
//
//    enum CodingKeys: String, CodingKey {
//
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//    }
//
//}


struct Payments : Codable {
    let statement_descriptor : String?
    let statement_descriptor_kana : String?
    let statement_descriptor_kanji : String?

    enum CodingKeys: String, CodingKey {

        case statement_descriptor = "statement_descriptor"
        case statement_descriptor_kana = "statement_descriptor_kana"
        case statement_descriptor_kanji = "statement_descriptor_kanji"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statement_descriptor = try values.decodeIfPresent(String.self, forKey: .statement_descriptor)
        statement_descriptor_kana = try values.decodeIfPresent(String.self, forKey: .statement_descriptor_kana)
        statement_descriptor_kanji = try values.decodeIfPresent(String.self, forKey: .statement_descriptor_kanji)
    }

}


struct Payouts : Codable {
    let debit_negative_balances : Bool?
    let schedule : Schedule?
    let statement_descriptor : String?

    enum CodingKeys: String, CodingKey {

        case debit_negative_balances = "debit_negative_balances"
        case schedule = "schedule"
        case statement_descriptor = "statement_descriptor"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        debit_negative_balances = try values.decodeIfPresent(Bool.self, forKey: .debit_negative_balances)
        schedule = try values.decodeIfPresent(Schedule.self, forKey: .schedule)
        statement_descriptor = try values.decodeIfPresent(String.self, forKey: .statement_descriptor)
    }

}



struct Requirements : Codable {
    let alternatives : [String]?
    let current_deadline : String?
    let currently_due : [String]?
    let disabled_reason : String?
    let errors : [String]?
    let eventually_due : [String]?
    let past_due : [String]?
    let pending_verification : [String]?

    enum CodingKeys: String, CodingKey {

        case alternatives = "alternatives"
        case current_deadline = "current_deadline"
        case currently_due = "currently_due"
        case disabled_reason = "disabled_reason"
        case errors = "errors"
        case eventually_due = "eventually_due"
        case past_due = "past_due"
        case pending_verification = "pending_verification"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        alternatives = try values.decodeIfPresent([String].self, forKey: .alternatives)
        current_deadline = try values.decodeIfPresent(String.self, forKey: .current_deadline)
        currently_due = try values.decodeIfPresent([String].self, forKey: .currently_due)
        disabled_reason = try values.decodeIfPresent(String.self, forKey: .disabled_reason)
        errors = try values.decodeIfPresent([String].self, forKey: .errors)
        eventually_due = try values.decodeIfPresent([String].self, forKey: .eventually_due)
        past_due = try values.decodeIfPresent([String].self, forKey: .past_due)
        pending_verification = try values.decodeIfPresent([String].self, forKey: .pending_verification)
    }

}



struct Schedule : Codable {
    let delay_days : Int?
    let interval : String?

    enum CodingKeys: String, CodingKey {

        case delay_days = "delay_days"
        case interval = "interval"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        delay_days = try values.decodeIfPresent(Int.self, forKey: .delay_days)
        interval = try values.decodeIfPresent(String.self, forKey: .interval)
    }

}



//struct Sepa_debit_payments : Codable {
//
//    enum CodingKeys: String, CodingKey {
//
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//    }
//
//}


struct Settings : Codable {
//    let bacs_debit_payments : Bacs_debit_payments?
  //  let branding : Branding?
    let card_issuing : Card_issuing?
    let card_payments : Card_payments?
    let dashboard : Dashboard?
    let payments : Payments?
    let payouts : Payouts?
//    let sepa_debit_payments : Sepa_debit_payments?

    enum CodingKeys: String, CodingKey {

//        case bacs_debit_payments = "bacs_debit_payments"
      //  case branding = "branding"
        case card_issuing = "card_issuing"
        case card_payments = "card_payments"
        case dashboard = "dashboard"
        case payments = "payments"
        case payouts = "payouts"
//        case sepa_debit_payments = "sepa_debit_payments"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        bacs_debit_payments = try values.decodeIfPresent(Bacs_debit_payments.self, forKey: .bacs_debit_payments)
       // branding = try values.decodeIfPresent(Branding.self, forKey: .branding)
        card_issuing = try values.decodeIfPresent(Card_issuing.self, forKey: .card_issuing)
        card_payments = try values.decodeIfPresent(Card_payments.self, forKey: .card_payments)
        dashboard = try values.decodeIfPresent(Dashboard.self, forKey: .dashboard)
        payments = try values.decodeIfPresent(Payments.self, forKey: .payments)
        payouts = try values.decodeIfPresent(Payouts.self, forKey: .payouts)
//        sepa_debit_payments = try values.decodeIfPresent(Sepa_debit_payments.self, forKey: .sepa_debit_payments)
    }

}

struct Tos_acceptance : Codable {
    let date : Int?

    enum CodingKeys: String, CodingKey {

        case date = "date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(Int.self, forKey: .date)
    }

}

//struct Bacs_debit_payments : Codable {
//
//    enum CodingKeys: String, CodingKey {
//
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//    }
//
//}
