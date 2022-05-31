//
//  EarningEventsTVC.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/30/21.
//

import UIKit
import SDWebImage

class EarningEventsTVC: UITableViewCell {

    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumberOfTickets: UILabel!
    @IBOutlet weak var lblRevenue: UILabel!
    
    var purchaseObject :  TopThree?{
        
        didSet{
            
            setupCell()
        }
    }
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCell(){
        
        imgEvent.sd_setImage(with: URL(string: purchaseObject?.image1_s3 ?? ""), placeholderImage: UIImage(named: "placeholder"))
        lblName.text = purchaseObject?.name
        lblNumberOfTickets.text = String(purchaseObject?.event_payments_and_verification_count ?? 0)
       // lblRevenue.text = "£"+String(purchaseObject?.event_payments_and_verification_sum_ticket_price ?? 0)
        lblRevenue.text = "£"+String(format: "%.2f", purchaseObject?.event_payments_and_verification_sum_ticket_price ?? 0)
    }
    
    static func getNib() -> UINib{
        return UINib(nibName: "\(EarningEventsTVC.self)", bundle: nil)
    }
    
}
