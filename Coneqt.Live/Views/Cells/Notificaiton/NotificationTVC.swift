//
//  NotificationTVC.swift
//  Coneqt.Live
//
//  Created by Azhar on 1/3/22.
//

import UIKit
import SDWebImage

class NotificationTVC: UITableViewCell {
    @IBOutlet weak var imgNotificaiton: UIImageView!
    @IBOutlet weak var btnStartEvent: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgNotificaiton.image = SVGKImage(named: "target").uiImage
        
        self.btnStartEvent.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .bold)
        
        self.btnStartEvent.layer.borderWidth = 1
        self.btnStartEvent.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func configureEarlier(with notification : Earlier){
        lblHeading.text = notification.title ?? ""
        let dateAndTime = notification.created_at?.convertToProjectFormat()
        lblDate.text = dateAndTime?.0 ?? ""
    }
    
    func configureToday(with notification : Today){
        lblHeading.text = notification.title ?? ""
        let dateAndTime = notification.created_at?.convertToProjectFormat()
        lblDate.text = dateAndTime?.0 ?? ""
    }
    
    static func getNib() -> UINib{
        return UINib(nibName: "\(NotificationTVC.self)", bundle: nil)
    }
    
}
