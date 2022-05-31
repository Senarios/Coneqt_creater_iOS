//
//  WithdrawViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/31/21.
//

import UIKit
import Foundation

class WithdrawViewController: BaseViewController {
    
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var imgNotification: UIImageView!
    
  //  @IBOutlet weak var lblNickName: UILabel!
 //   @IBOutlet weak var imgProfile: UIImageView!
 //   @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var lblNameCaption: UILabel!
    @IBOutlet weak var vNameBox: UIView!
    
    @IBOutlet weak var imgAmount: UIImageView!
    @IBOutlet weak var imgOtherAmount: UIImageView!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var vNotification: UIView!
    @IBOutlet weak var vOtherAmount: UIView!
    @IBOutlet weak var vAmount: UIView!
    
    @IBOutlet weak var tfOtherAmount: UITextField!
    
    @IBOutlet weak var lblAvailableBalanceValue: UILabel!
    @IBOutlet weak var lblPendingBalanceValue: UILabel!
    @IBOutlet weak var lblAvailableAmount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var btnPay: UIButton!
    
    var amountSelected: Bool = true
    var availableAmount = 0.0
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setControls()
    }
    
    // MARK: - Class Functions
    func setControls(){
        self.view.backgroundColor = Colors.SCREENS_BACKGROUND_COLOR
        self.vHeader.layer.cornerRadius = 80
        self.vHeader.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        
        self.imgNotification.image = SVGKImage(named: "notification").uiImage
        self.imgBack.image = SVGKImage(named: "back").uiImage
        
        self.imgAmount.image = SVGKImage(named: "rb_selected").uiImage
        self.imgOtherAmount.image = SVGKImage(named: "rb_unselected").uiImage
        
        self.btnPay.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        
        self.vAmount.layer.borderWidth = 0.5
        self.vAmount.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.btnPay.layer.borderWidth = 2
        self.btnPay.layer.borderColor = UIColor.black.cgColor
        
        self.vOtherAmount.layer.cornerRadius = 5
        self.vOtherAmount.layer.borderWidth = 1
        self.vOtherAmount.layer.borderColor = Colors.FIELD_BORDER_COLOR.cgColor
        
        self.tfOtherAmount.isEnabled = false
        self.tfOtherAmount.delegate = self
        
        if Defaults.imageUrl.count == 0 {
            self.lblNameCaption.text = (Defaults.firstName.count > 0 ? String(Defaults.firstName.prefix(1)) : "") + (Defaults.lastName.count > 0 ? String(Defaults.lastName.prefix(1)) : "")
            self.vNameBox.isHidden = false
        }
        
        checkBalance()
        updateNotificationDot()
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
    @IBAction func Back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Amount_Clicked(_ sender: Any) {
        self.amountSelected = true
        self.imgAmount.image = SVGKImage(named: "rb_selected").uiImage
        self.imgOtherAmount.image = SVGKImage(named: "rb_unselected").uiImage
        self.tfOtherAmount.isEnabled = false
        
        self.lblTotalAmount.text =  self.lblAvailableAmount.text!
        self.btnPay.setTitle("PAY " + self.lblAvailableAmount.text!, for:.normal)
    }
    
    @IBAction func OtherAmount_Clicked(_ sender: Any) {
        self.amountSelected = false
        self.imgAmount.image = SVGKImage(named: "rb_unselected").uiImage
        self.imgOtherAmount.image = SVGKImage(named: "rb_selected").uiImage
        self.tfOtherAmount.isEnabled = true
        
        var otherAmount = self.tfOtherAmount.text!
        if(otherAmount.count > 0){
            self.lblTotalAmount.text = "£" + otherAmount
            self.btnPay.setTitle("PAY £" + otherAmount, for:.normal)
        }
        else
        {
            self.lblTotalAmount.text = "£0.0"
            self.btnPay.setTitle("PAY £0.0", for:.normal)
        }
    }
    
    @IBAction func Notifications_Clicked(_ sender: Any) {
        print("donnnnnnn")
        let vc = ViewControllers.get(NotificationViewController(), from: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Pay_Clicked(_ sender: Any) {
       // self.navigationController?.popViewController(animated: true)
        if(self.amountSelected )
        {
            withdrawBalance(selectedAmount: self.availableAmount)
            print(self.availableAmount)
        }
        else
        {
            let otherAmount = self.tfOtherAmount.text!
            
            if(otherAmount.isEmpty){
                Toast.show(message: "Please enter Amount", controller: self)
            }
            else{
                let otherAmountValue = Double(otherAmount)
                if(otherAmountValue == 0){
                    Toast.show(message: "Amount must be greater than 0", controller: self)
                }else if (otherAmountValue! > self.availableAmount){
                    Toast.show(message: "Amount must be less than Available balance", controller: self)
                }
                else
                {
                    withdrawBalance(selectedAmount: otherAmountValue!)
                }
            }
            
        }
    }
    // MARK: - Call API
    
    private func checkBalance(){
      
        if Defaults.connectId != nil{
     
            let apiService = APIManager(controller: self,endPoint: .balance)
            apiService.postTest(model: BalanceModel.self) { [weak self] result in
                
                switch result{
                case .success(let balance):
                    self?.lblPendingBalanceValue.text = "£"+String(balance.pending)
                    
                    self?.availableAmount = balance.available
                    
                    self?.lblAvailableBalanceValue.text = "£"+String(balance.available)
                    self?.lblAvailableAmount.text = "£"+String(balance.available)
                    self?.lblTotalAmount.text = "£"+String(balance.available)
                    self?.btnPay.setTitle("PAY £"+String(balance.available), for:.normal)
                    
                 
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
    }
    
    private func withdrawBalance(selectedAmount: Double){
      
        if Defaults.connectId != nil{
            self.startAnimating()
           // let otherAmount = self.tfOtherAmount.text!
            let parameters = [
                "amount":selectedAmount
            ]
            
            let apiService = APIManager(controller: self, parameters: parameters, endPoint: .payout)
            apiService.postTest(model: PayoutModel.self) { [weak self] result in
                
                switch result{
                case .success(let payout):
                    self?.checkBalance()
                    print("payout ::", payout)
                    self?.stopAnimating()
                case .failure(let error):
                    print(error.errorDescription)
                    self?.stopAnimating()
                }
            }
        }
    }
    
}

extension WithdrawViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField){
        print(textField.text)
        var amountData = textField.text!
        if(amountData.count > 0){
            self.lblTotalAmount.text = "£" + amountData
            self.btnPay.setTitle("PAY £" + amountData, for:.normal)
        }
        else
        {
            self.lblTotalAmount.text = "£0.0"
            self.btnPay.setTitle("PAY £0.0", for:.normal)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        print(textField.text)
        return true
    }
}
