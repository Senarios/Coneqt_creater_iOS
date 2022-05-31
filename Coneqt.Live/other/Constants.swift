//
//  Constants.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 29/11/2021.
//

import Foundation
import UIKit

  

struct KeyCenter {
    
    static var token = ""
    static var AppId = ""
    static var channelName = "zain"
    

    
    static let publishKey = ""
    
    static let secretKey = ""
}

struct APIEndPoints {
    
    
    static let baseUrl = ""
    static let baseImageUrl = ""
    static let createEvent = baseUrl+"/create_event"
    static let getUserEvents = baseUrl+"/event_list"
    static let startEvent = baseUrl+"/start_event"
    static let endEvent = baseUrl+"/event_completed"
    static let balance = baseUrl+"/stripe/balance"
    static let updateProfile = baseUrl+"/settings"
    static let updateConnectAccountId = baseUrl+""
    static let getBlockedusers = baseUrl+"/blocked_users"
    static let getNotificationCount = baseUrl+"/notification/count"
    static let unblockuser = baseUrl+"/unblock_user"
    static let userData = baseUrl+"/settings"
    static let cancelEvent = baseUrl+""
   
    
}


enum EndPoint : String{
    
    /// Backend Api
    case overview = "overview"
    case kickout = "viewer/kickout"
    case blockUsers = "blocked_users"
    case blockUser = "block_user"
    case kickoutUser = "viewer/kick/out"
    case socialLogin = "social_signup_login"
    case notifications = "notification"
    case unblock_user = "unblock_user"
    case filterStats = "overview/event/stats/filter"
    case cancelEvent = "stripe/payout/refund"
    case change_password_settings = "change_password_settings"
    case logout = "logout"
    
    /// stripe
    case balance = "stripe/balance"
    case connectAccountStatus = "stripe/check"
    case payout = "stripe/payout"
    case setSendNotifications = "desktop_notification"
}


struct Scene
{
    static let SplashVC = "SplashViewController"
    static let GetStartedVC = "GetStartedViewController"

}

// Segue ID
struct Segues
{
    static let Splash_to_GetStarted = "Splash_to_GetStarted"
    static let GetStarted_To_Signin = "GetStarted_To_Signin"
    static let SignIn_To_Signup = "SignIn_To_Signup"
    static let SignUp_To_Verification = "SignUp_To_Verification"
    static let Signin_To_ForgotPassword = "Signin_To_ForgotPassword"
    static let ForgotPassword_To_ResetPassword = "ForgotPassword_To_ResetPassword"
    
    static let SignIn_To_Stream = "SignIn_To_Stream"
    static let Signup_To_FirstEvent = "Signup_To_FirstEvent"
    static let FirstEvent_To_CreateEvent = "FirstEvent_To_CreateEvent"
    static let CreateEvent_To_History = "CreateEvent_To_History"
    static let ForgotPassword_to_Verification = "ForgotPassword_to_Verification"
    static let ForgotPassword_to_ResetPassword = "ForgotPassword_to_ResetPassword"
    
}

struct Colors
{
    static let MAIN_BACKGROUND_COLOR = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0) // #a2d9f6
    static let SCREENS_BACKGROUND_COLOR = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0) // #a2d9f6
    
    static let FIELD_BORDER_COLOR = UIColor(red: 130/255.0, green: 130/255.0, blue: 130/255.0, alpha: 1.0)
    static let ERROR_BUTTON_BG = UIColor(red: 255/255.0, green: 99/255.0, blue: 72/255.0, alpha: 1.0)
    static let ERROR_BLUE_BG = UIColor(red: 30/255.0, green: 144/255.0, blue: 255/255.0, alpha: 1.0)
    static let GOLDEN_DARK_BUTTON_BG = UIColor(red: 238/255.0, green: 203/255.0, blue: 109/255.0, alpha: 1.0)
    static let BLUE_BUTTON_BG = UIColor(red: 146/255.0, green: 213/255.0, blue: 252/255.0, alpha: 1.0)
    static let DISABLED_BUTTON_BG = UIColor(red: 172/255.0, green: 180/255.0, blue: 190/255.0, alpha: 1.0)
    
    static let LIGHT_GRAY_COLOR = UIColor(red: 214/255.0, green: 214/255.0, blue: 214/255.0, alpha: 1.0)
    
    static let TABBAR_BACKGROUNDS = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
    static let PLACEHOLDER_TEXTFIELD = UIColor(red: 0.138, green: 0.138, blue: 0.138, alpha: 0.6)
}

struct NotificationName
{
    static let RELOAD_EVENT = Notification.Name("RELOAD_EVENT")
    static let NOTIFICATION_DETECTED = Notification.Name("NOTIFICATION_DETECTED")
}


struct Messages{
    
    static let noAccountFound = "Please first connect with stripe to create Event"
    static let noAccountEnable = "Please first complete your profile to create Event"

}



struct Defaults {
    
    static var isUserLogin : Bool{
        
        set{
            
            UserDefaults.standard.setValue(newValue, forKey: "isUserLogin")
        }
        get{
            
            return UserDefaults.standard.bool(forKey: "isUserLogin")
        }
    }
    
    static var backEndToken : String?{
        
        set{
            
            UserDefaults.standard.setValue(newValue, forKey: "backEndToken")
        }
        get{
            
            return UserDefaults.standard.string(forKey: "backEndToken") ?? ""
        }
    }
    
    static var email : String?{
        
        set{
            
            UserDefaults.standard.setValue(newValue, forKey: "email")
        }
        get{
            
            return UserDefaults.standard.string(forKey: "email") ?? nil
        }
    }
    
    static var connectId : String?{
        
        set{
            
            UserDefaults.standard.setValue(newValue, forKey: "connectId")
        }
        get{
            
            return UserDefaults.standard.string(forKey: "connectId") ?? nil
        }
    }
    
    static var userId : Int{
        
        set{
            
            UserDefaults.standard.setValue(newValue, forKey: "userId")
        }
        get{
            
            return UserDefaults.standard.integer(forKey: "userId")
        }
    }
    
    static var firstName : String{
        
        set{
            
            UserDefaults.standard.setValue(newValue, forKey: "firstName")
        }
        get{
            
            return UserDefaults.standard.string(forKey: "firstName") ?? ""
        }
    }
    
    static var lastName : String{
        
        set{
            
            UserDefaults.standard.setValue(newValue, forKey: "lastName")
        }
        get{
            
            return UserDefaults.standard.string(forKey: "lastName") ?? ""
        }
    }
    
    static var phoneNumber : String{
        
        set{
            
            UserDefaults.standard.setValue(newValue, forKey: "phoneNumber")
        }
        get{
            
            return UserDefaults.standard.string(forKey: "phoneNumber") ?? ""
        }
    }
    
    static var imageUrl : String{
        
        set{
            
            UserDefaults.standard.setValue(newValue, forKey: "imageUrl")
        }
        get{
            
            return UserDefaults.standard.string(forKey: "imageUrl") ?? ""
        }
    }
    
    static var isConnectAccountEnable : Bool{
        
        set{
            
            UserDefaults.standard.setValue(newValue, forKey: "isConnectAccountEnable")
        }
        get{
            
            return UserDefaults.standard.bool(forKey: "isConnectAccountEnable") ?? false
        }
    }
    
    static var fcmToken : String?{
        
        set{
            
            UserDefaults.standard.setValue(newValue, forKey: "fcmToken")
        }
        get{
            
            return UserDefaults.standard.string(forKey: "fcmToken") 
        }
    }


    static func clear(){
        print("clear fun run")
        Defaults.isUserLogin = false
        UserDefaults.standard.removeObject(forKey: "connectId")
        UserDefaults.standard.removeObject(forKey: "backEndToken")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastName")
        UserDefaults.standard.removeObject(forKey: "imageUrl")
        UserDefaults.standard.removeObject(forKey: "isConnectAccountEnable")
    }


}

struct Cashe{
    
    static var balance = ""
    static var isUpdateRequire = false
    static var totalEvents = "0"
    static var totalRevenue = "£0"
    static var totalSoldTickets = "0"
    static var totalRefund = "£0"
    static var overViewScreenRefreshRequired = false
    static var filterModel : FilterModel?
    static var shareEventUrl : String?
    static var streamParticipents = [StreamParticipent]()
    static var notificationCount = 0
}

