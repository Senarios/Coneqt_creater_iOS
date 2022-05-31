
import Foundation

struct UserModel : Codable {
    let success : Bool?
    let message : String?
    let user : User?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case user = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        user = try values.decodeIfPresent(User.self, forKey: .user)
    }

}


struct User : Codable {
    
    let id : Int?
    let first_name : String?
    let last_name : String?
    let email : String?
    let auth_type : String?
    let social_id : String?
    let email_verified_at : String?
    let phone : String?
    let verification_code : Int?
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
        verification_code = try values.decodeIfPresent(Int.self, forKey: .verification_code)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        stripe_account_id = try values.decodeIfPresent(String.self, forKey: .stripe_account_id)
        stripe_payout = try values.decodeIfPresent(Int.self, forKey: .stripe_payout)
        api_token = try values.decodeIfPresent(String.self, forKey: .api_token)
        social_image_url = try values.decodeIfPresent(String.self, forKey: .social_image_url)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}
