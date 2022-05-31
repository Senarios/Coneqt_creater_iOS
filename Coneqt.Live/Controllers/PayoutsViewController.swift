//
//  PayoutsViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/29/21.
//

import UIKit
import Foundation
import DropDown
import StripeUICore

class PayoutsViewController: BaseViewController {
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var imgNotification: UIImageView!
    
    @IBOutlet weak var lblNameCaption: UILabel!
    @IBOutlet weak var vNameBox: UIView!
    
    @IBOutlet weak var vBGBalances: UIView!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var vFilter: UIView!
    @IBOutlet weak var vDropDown: UIView!
    
    @IBOutlet weak var vNotification: UIView!
    @IBOutlet weak var imgTotalRevenue: UIImageView!
    @IBOutlet weak var imgTotalEvents: UIImageView!
    @IBOutlet weak var imgTotalRefund: UIImageView!
    @IBOutlet weak var imgTotalSold: UIImageView!
    @IBOutlet weak var imgBalances: UIImageView!
    @IBOutlet weak var btnWithdrawAllEarnings: UIButton!
    
    /// Analytics Outlet
    
    @IBOutlet weak var lblTotalEvents: UILabel!
    @IBOutlet weak var lblTotalRevenue: UILabel!
    @IBOutlet weak var lblTotalSoldTickets: UILabel!
    @IBOutlet weak var lblTotalRefund: UILabel!

    @IBOutlet weak var lblAvailableBalance: UILabel!
    @IBOutlet weak var lblPendingBalance: UILabel!
    @IBOutlet weak var lblFilterStatus: UILabel!
    
    var apiIndex = 4
    
    var dropDown : DropDown!
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.TABBAR_BACKGROUNDS
        self.setControls()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear(_:) called")
        checkBalance()
        
    }

    func setup(){
        
        updateData()
      //  checkBalance()
        self.filterCall(self.apiIndex)
        
        self.vNameBox.isHidden = true
        if Defaults.imageUrl.count == 0 {
            self.lblNameCaption.text = (Defaults.firstName.count > 0 ? String(Defaults.firstName.prefix(1)) : "") + (Defaults.lastName.count > 0 ? String(Defaults.lastName.prefix(1)) : "")
            self.vNameBox.isHidden = false
        }
            
    }
    
    // MARK: - Class Functions
    func setControls(){
        self.view.backgroundColor = Colors.SCREENS_BACKGROUND_COLOR
        self.vHeader.layer.cornerRadius = 80
        self.vHeader.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        
        self.imgNotification.image = SVGKImage(named: "notification").uiImage
        self.imgDropDown.image = SVGKImage(named: "dropdown_head").uiImage
        
        self.vFilter.layer.borderWidth = 1
        self.vFilter.layer.borderColor = UIColor.gray.cgColor
        vFilter.isUserInteractionEnabled = true
        vFilter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFilterView)))
        
        self.btnWithdrawAllEarnings.layer.borderWidth = 2
        self.btnWithdrawAllEarnings.layer.borderColor = UIColor.black.cgColor
        
        self.imgTotalRevenue.image = SVGKImage(named: "revenue").uiImage
        self.imgTotalEvents.image = SVGKImage(named: "total_events").uiImage
        self.imgTotalRefund.image = SVGKImage(named: "total_refund").uiImage
        self.imgTotalSold.image = SVGKImage(named: "tickets").uiImage
        self.imgBalances.image = SVGKImage(named: "balance_scale").uiImage
        
        self.vNotification.isHidden = true
        
        self.vBGBalances.addShadow(offset: CGSize.init(width: 0, height: 0.3), color: UIColor.black, radius: 1.5, opacity: 0.2)
        self.btnWithdrawAllEarnings.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        
        self.vNameBox.isHidden = true
        if Defaults.imageUrl.count == 0 {
            self.lblNameCaption.text = (Defaults.firstName.count > 0 ? String(Defaults.firstName.prefix(1)) : "") + (Defaults.lastName.count > 0 ? String(Defaults.lastName.prefix(1)) : "")
            self.vNameBox.isHidden = false
        }
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        /// setUp DropDown
        
        dropDown = DropDown(anchorView: vDropDown)
        dropDown.dataSource =  ["Today","This week","This Month","This Year","All"]
        dropDown.width = 120
        dropDown.direction = .bottom
        dropDown.selectionAction = {index,value in
            print(index,value)
            self.apiIndex = index
            self.filterCall(index)
            self.lblFilterStatus.text = value
        }
    }
    
    func updateNotificationDot(){
        if(Cashe.notificationCount == 0){
            self.vNotification.isHidden = true
        }
        else
        {
            self.vNotification.isHidden = false
        }
    }
    
    // MARK: - Control Actions
    
    @IBAction func WithdrawAllEarnings_Clicked(_ sender: Any) {
        print("donnnnnnn")
        let vc = ViewControllers.get( WithdrawViewController(), from: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Notifications_Clicked(_ sender: Any) {
        print("donnnnnnn")
        let vc = ViewControllers.get(NotificationViewController(), from: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Call API
    
}


extension PayoutsViewController{
    
    //MARK:- @OBJC FUNC
    @objc func didTapFilterView(){
        print("did tap filter view ")
        dropDown.show()
    }
}

/// API CALLINGS
extension PayoutsViewController{
    
    private func checkBalance(){
        if Defaults.connectId != nil{
            let apiService = APIManager(controller: self,endPoint: .balance)
            apiService.postTest(model: BalanceModel.self) { [weak self] result in
                
                switch result{
                case .success(let balance):
                    self?.lblAvailableBalance.text = "£"+String(balance.available)
                    self?.lblPendingBalance.text = "£"+String(balance.pending)
                    self?.lblTotalEvents.text = String(balance.events)
                    self?.lblTotalRevenue.text = "£"+String(balance.revenue)
                    
                    self?.lblTotalSoldTickets.text = String(balance.ticket)
                    self?.lblTotalRefund.text = "£"+String(balance.refund)
                 
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
    }
    
    private func filterCall(_ index : Int){
        let param  = ["stat":index+1]
        let apiManager = APIManager(controller: self, headerType: .backend, parameters: param, endPoint: .filterStats, method: .post)
        startAnimating()
        apiManager.postTest(model: FilterBalanceModel.self) { [weak self] response in
            self?.stopAnimating()
            switch response{
            case .success(let model):
                self?.lblTotalEvents.text = String(model.total_events)
                self?.lblTotalRevenue.text = "£"+String(model.revenue)
                self?.lblTotalSoldTickets.text = String(model.tickets)
                self?.lblTotalRefund.text = "£"+String(model.refunds)
                
            case .failure(let error):
                self?.showToastMessage(message: error.errorDescription)
            }
        }
    }
}
