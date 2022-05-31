//
//  CancelEventNotificationTVC.swift
//  Coneqt.Live
//
//  Created by Azhar on 1/12/22.
//

import UIKit

class CancelEventNotificationTVC: UITableViewCell {

    @IBOutlet weak var imgNotificaiton: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgNotificaiton.image = SVGKImage(named: "revenue").uiImage
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureEarlier(with notification : Earlier){
        lblHeading.text = notification.title ?? ""
       // lblBody.text = notification.body ?? ""

     //   let dateAndTime = notification.created_at?.convertToProjectFormat()
        lblDate.text = notification.created_at!.convertToNotificationFormat() //dateAndTime?.0 ?? ""
    }
    
    func configureToday(with notification : Today){
        lblHeading.text = notification.title ?? ""
        let dateAndTime = notification.created_at?.convertToNotificationFormat()
        lblDate.text = dateAndTime
    }
    
    static func getNib() -> UINib{
        return UINib(nibName: "\(CancelEventNotificationTVC.self)", bundle: nil)
    }
    
}
