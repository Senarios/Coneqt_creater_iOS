//
//  GreatNewsNotifyTVC.swift
//  Coneqt.Live
//
//  Created by Azhar on 1/12/22.
//

import UIKit

class GreatNewsNotifyTVC: UITableViewCell {

    @IBOutlet weak var imgNotificaiton: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblBody: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.imgNotificaiton.image = SVGKImage(named: "revenue").uiImage
        self.imgNotificaiton.image = SVGKImage(named: "fire").uiImage
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
    func configureEarlier(with notification : Earlier){
        if(notification.type == "balance_info"){
            self.imgNotificaiton.image = SVGKImage(named: "revenue").uiImage
        }
        else{
            self.imgNotificaiton.image = SVGKImage(named: "fire").uiImage
        }
        lblHeading.text = notification.title ?? ""
        let bodyData = notification.body ?? ""
        lblBody.text = bodyData
        
        var poundIndex: Int = 0
        if let firstIndex = bodyData.firstIndex(of: "£") {
            let index: Int = bodyData.distance(from: bodyData.startIndex, to: firstIndex)
            poundIndex = index
            print("index: ", index)   //index: 2
        }
        print("poundIndex:", poundIndex)
        if(poundIndex == 0){
            lblBody.text = bodyData
        }
        else
        {
            let amountData = bodyData.subString(from: poundIndex, to: bodyData.count)
            let stringWithoutAmount = bodyData.replacingOccurrences(of: amountData, with: "")
        
            let boldAttribute = [
              NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 12.0)!
            ]
            let regularAttribute = [
              NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 12.0)!
            ]
            let boldText = NSAttributedString(string: amountData, attributes: boldAttribute)
            let regularText = NSAttributedString(string: stringWithoutAmount, attributes: regularAttribute)
            let newString = NSMutableAttributedString()
           
            newString.append(regularText)
            newString.append(boldText)
            lblBody.attributedText = newString
        }
        
 //       let dateAndTime = notification.created_at?.convertToProjectFormat()
        lblDate.text = notification.created_at!.convertToNotificationFormat() // dateAndTime?.0 ?? ""
    }
    
    func configureToday(with notification : Today){
        if(notification.type == "balance_info"){
            self.imgNotificaiton.image = SVGKImage(named: "revenue").uiImage
        }
        else{
            self.imgNotificaiton.image = SVGKImage(named: "fire").uiImage
        }
            
        lblHeading.text = notification.title ?? ""
        let bodyData = notification.body ?? ""
        lblBody.text = bodyData
        
        var poundIndex: Int = 0
        if let firstIndex = bodyData.firstIndex(of: "£") {
            let index: Int = bodyData.distance(from: bodyData.startIndex, to: firstIndex)
            poundIndex = index
            print("index: ", index)   //index: 2
        }
        print("poundIndex:", poundIndex)
        if(poundIndex == 0){
            lblBody.text = bodyData
        }
        else
        {
            let amountData = bodyData.subString(from: poundIndex, to: bodyData.count)
            let stringWithoutAmount = bodyData.replacingOccurrences(of: amountData, with: "")
        
            let boldAttribute = [
              NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 12.0)!
            ]
            let regularAttribute = [
              NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 12.0)!
            ]
            let boldText = NSAttributedString(string: amountData, attributes: boldAttribute)
            let regularText = NSAttributedString(string: stringWithoutAmount, attributes: regularAttribute)
            let newString = NSMutableAttributedString()
           
            newString.append(regularText)
            newString.append(boldText)
            lblBody.attributedText = newString
        }
  //      let dateAndTime = notification.created_at?.convertToProjectFormat()
        lblDate.text = notification.created_at?.convertToNotificationFormat() //dateAndTime?.0 ?? ""
    }
    
    static func getNib() -> UINib{
        return UINib(nibName: "\(GreatNewsNotifyTVC.self)", bundle: nil)
    }
    
}
extension String {
    func subString(from: Int, to: Int) -> String {
       let startIndex = self.index(self.startIndex, offsetBy: from)
       let endIndex = self.index(self.startIndex, offsetBy: to)
       return String(self[startIndex..<endIndex])
    }
}
