//
//  HistoryTVC.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/27/21.
//

import UIKit
import SVGKit
import SDWebImage

protocol HistoryDelegate: AnyObject {
    func StartEvent(_ event: Upcoming)
    func CancelEvent(_ index: Int)
    func shareEvent(_ linkToOpen : String, linkToShow : String)
}

class HistoryTVC: UITableViewCell {

    weak var delegate: HistoryDelegate?
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var vRating: CosmosView!
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTicketPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTotalTicketSolds: UILabel!
    @IBOutlet weak var lblTotalRevenue: UILabel!
    @IBOutlet weak var btnCancelEvent: UIButton!
    @IBOutlet weak var btnStartEvent: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var vBGShadow: UIView!
    @IBOutlet weak var vBG: UIView!
    @IBOutlet weak var imgShare: UIImageView!
   
    @IBOutlet weak var vShare: UIView!
    @IBOutlet weak var imgRevenue: UIImageView!
    @IBOutlet weak var imgAmount: UIImageView!
    @IBOutlet weak var imgTicket: UIImageView!
    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblPastHourSubs: UILabel!
    
    @IBOutlet weak var lblPastHourBracket: UILabel!
    @IBOutlet weak var lblPastHourText: UILabel!
    
    @IBOutlet weak var ticketCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var revenueBottomConstraint: NSLayoutConstraint!
    var index = -1
    
    var upcomingEvent : Upcoming? {
        
        didSet{
            print("come in upcoming cell")
            setupUpcomingCell()
        }
    }
    
    
    var pastEvent : Past? {
        
        didSet{
            print("come in past cell")
            setupPastCell()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgTime.image = SVGKImage(named: "clock").uiImage
        self.imgTicket.image = SVGKImage(named: "tickets").uiImage
        self.imgAmount.image = SVGKImage(named: "amount").uiImage
        self.imgRevenue.image = SVGKImage(named: "revenue").uiImage
        self.imgShare.image = SVGKImage(named: "share").uiImage
        btnShare.setTitle("", for: .normal)
      //  self.btnCancelEvent.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .bold)
      //  self.btnStartEvent.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .bold)
        
        self.btnCancelEvent.layer.borderWidth = 1
        self.btnCancelEvent.layer.borderColor = UIColor.black.cgColor

        imageEvent.clipsToBounds = true
    }
    

    
  

    private func setupUpcomingCell(){
        
        guard let event = upcomingEvent else{
            return
        }
        imageEvent.sd_setImage(with: URL(string: event.image1_s3 ?? ""), placeholderImage: UIImage(named: "placeholder"))
        lblTitle.text = event.name
        lblDescription.text = event.description
        lblTicketPrice.text = "£"+String(event.ticket_price ?? 0)
        print("Event price",event.ticket_price)
        print("Event price",event.event_payments_and_verification_sum_ticket_price)
        print("Event price",event.event_payments_and_verification_count)
        lblTotalTicketSolds.text = String(event.event_payments_and_verification_count ?? 0)
        lblTotalRevenue.text = "£"+String(event.event_payments_and_verification_sum_ticket_price ?? 0)
        let dateAndTime = event.time?.convertToEventFormat()
        let elapsedTime = event.time?.getCurrentTimeDifference()
        let lTotalMinutes = (event.time_duration!) / 60
        let lHours = lTotalMinutes / 60
        let lMinutes = lTotalMinutes % 60
      
        var NewTime = ""
        if(lHours > 0){
            NewTime = "\(lHours)h "
        }
        if(lMinutes > 0){
            NewTime += "\(lMinutes)min"
        }
          
        lblDate.text = "Time: \(dateAndTime?.1 ?? "") \(dateAndTime?.0 ?? "") | \(NewTime)"
        lblTime.text = elapsedTime

        btnStartEvent.isHidden = false
        btnCancelEvent.isHidden = false
        lblType.text = event.type
        lblPastHourSubs.text = "\((event.lastHourTicketPurchased)!)"
        lblPastHourSubs.isHidden = false
        lblPastHourBracket.isHidden = false
        lblPastHourText.isHidden = false
        vShare.isHidden = false
        lblTime.isHidden = false
        ticketCenterConstraint.constant = 0
        revenueBottomConstraint.constant = 85
        lblTotalTicketSolds.text = "\(event.totalTicketPurchased!)"
        lblTotalRevenue.text = "£"+"\(event.totalEventRevenue!)"
        vRating.isHidden = true
        lblRating.isHidden = true
        vRating.isUserInteractionEnabled = false
    }
    
    private func setupPastCell(){
        
        guard let event = pastEvent else{
            return
        }
     
        imageEvent.sd_setImage(with: URL(string: event.image1_s3 ?? ""), placeholderImage: UIImage(named: "placeholder"))
        lblTitle.text = event.name
        lblDescription.text = event.description
        lblTicketPrice.text = "£"+String(event.ticket_price ?? 0)
        let dateAndTime = event.time?.convertToEventFormat()
      //  let elapsedTime = event.time?.getCurrentTimeDifference()
        let lTotalMinutes = (event.time_duration!) / 60
        let lHours = lTotalMinutes / 60
        let lMinutes = lTotalMinutes % 60
        
        var NewTime = ""
        if(lHours > 0){
            NewTime = "\(lHours)h "
        }
        if(lMinutes > 0){
            NewTime += "\(lMinutes)min"
        }
        
        lblDate.text = "Time: \(dateAndTime?.1 ?? "") \(dateAndTime?.0 ?? "") | \(NewTime)"
      //  lblTime.text = elapsedTime
        lblTime.isHidden = true
        btnStartEvent.isHidden = true
        btnCancelEvent.isHidden = true
        lblType.text = event.type
        lblPastHourSubs.isHidden = true
        lblPastHourBracket.isHidden = true
        lblPastHourText.isHidden = true
        vShare.isHidden = true
        ticketCenterConstraint.constant = -8
        revenueBottomConstraint.constant = 30
        lblTotalTicketSolds.text = "\(event.totalTicketPurchased!)"
        lblTotalRevenue.text = "£"+"\(event.totalEventRevenue!)"
        let ratingCount = event.avg_rating == nil ? 0.0 : event.avg_rating!
        vRating.rating = ratingCount
        lblRating.text = "(\(ratingCount))"
        vRating.isUserInteractionEnabled = false
        vRating.isHidden = false
        lblRating.isHidden = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func getNib() -> UINib{
        return UINib(nibName: "\(HistoryTVC.self)", bundle: nil)
    }
    
    @IBAction func didTapOnShare(_ sender: UIButton) {
        print("did tap on share")
        
        
//        let url = URL(string: upcomingEvent.link?.toOpen ?? ""){
      
        
        if let upcomingEvent = upcomingEvent{
            print(upcomingEvent.link?.toShow)
            delegate?.shareEvent(upcomingEvent.link?.toOpen ?? "", linkToShow: upcomingEvent.link?.toShow ?? "")
        }
        
    }
    @IBAction func StartEvent_Clicked(_ sender: Any) {
        if let upcomingEvent = upcomingEvent{
            self.delegate?.StartEvent(upcomingEvent)
        }
    }
    @IBAction func CancelEvent_Clicked(_ sender: Any) {
        self.delegate?.CancelEvent(index)
    }
}




