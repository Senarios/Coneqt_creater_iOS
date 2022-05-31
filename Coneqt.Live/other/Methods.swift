//
//  Methods.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 03/12/2021.
//

import Foundation

class Methods{
    
    static let shared = Methods()
    private init(){}
    
    func toggle(_ value : inout Bool) -> Bool{
        if value{
            value = false
            return value
        }
        value = true
        return value
    }
    
    
    func charAt(_ index : Int, _ data : String) -> Character?{
        
        if data.count < index{
            return nil
        }
        var counter = 0
        for item in data{
            
            if index == counter{
                return item
            }
            counter+=1
        }
        return nil
    }
    
    
    func trimLast(to num : Int, _ data : String) -> String {
        if data.count < num{
            return ""
        }
        
        let lastIndex = data.count - num
        var counter = 0
        var filterData = ""
        for item in data {
            
            if counter == lastIndex{
                break
            }
            filterData.append(item)
            counter+=1
            
            
            
        }
        return filterData
    }
    
    func stringToUrl(_ string : String) -> URL?{
        
        return URL(string: string)
        
    }
    
    
    func nickName() -> String{
        return "@"+Defaults.firstName+"_"+Defaults.lastName
    }
    
    func convertDate24To12(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
     //   dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
       // dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: date)

        return timeStamp
    }
}






extension UITextField{
    
    func setPlaceHolder(_ string : String,_ color : UIColor){
        
        let attribute = [
            NSAttributedString.Key.foregroundColor : Colors.PLACEHOLDER_TEXTFIELD,
            NSAttributedString.Key.font : Fonts.get(type: .Montserrat_Regular, size: 12)
        ]
        self.attributedPlaceholder = NSAttributedString(string: string, attributes: attribute)
    }
    
}
