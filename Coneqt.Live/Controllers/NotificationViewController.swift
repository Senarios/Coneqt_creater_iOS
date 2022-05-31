//
//  NotificationViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/31/21.
//

import UIKit
import Foundation

class NotificationViewController: BaseViewController {
    
    @IBOutlet weak var vHeader: UIView!
    
    
    
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var vTodayNotification: UIView!
    @IBOutlet weak var vEarlyNotification: UIView!
    
    @IBOutlet weak var vBodyView: UIView!
    
    @IBOutlet weak var lblNameCaption: UILabel!
    @IBOutlet weak var vNameBox: UIView!
    
    @IBOutlet weak var tvEarlyNotifications: UITableView!
    @IBOutlet weak var tvTodayNotifications: UITableView!
    @IBOutlet weak var vEarlyNotificationHeight: NSLayoutConstraint!
    @IBOutlet weak var vTodayNotificationHeight: NSLayoutConstraint!
    @IBOutlet weak var lblNoEralyNotifications : UILabel!
    @IBOutlet weak var lblNoTodayNotifications : UILabel!
    
    var today = [Today]()
    var earlier = [Earlier]()
    var earlyCount = 0
    var todayCount = 0
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setControls()
    }
    
    // MARK: - Class Functions
    func setControls(){
        
   
        
        self.view.backgroundColor = Colors.TABBAR_BACKGROUNDS
        self.vHeader.layer.cornerRadius = 80
        self.vHeader.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        lblNoEralyNotifications.font = Fonts.get(type: .Montserrat_Regular, size: 14)
        lblNoTodayNotifications.font = Fonts.get(type: .Montserrat_Regular, size: 14)
    
        self.imgBack.image = SVGKImage(named: "back").uiImage
        
        self.vTodayNotification.addShadow(offset: CGSize.init(width: 0, height: 0.3), color: UIColor.black, radius: 1.5, opacity: 0.2)
        
        self.vBodyView.addShadow(offset: CGSize.init(width: 0, height: 0.3), color: UIColor.black, radius: 1.5, opacity: 0.2)
        
        
        tvTodayNotifications.delegate = self
        tvTodayNotifications.dataSource = self
        self.tvEarlyNotifications.delegate = self
        self.tvEarlyNotifications.dataSource = self
        
        self.tvEarlyNotifications.allowsSelection = false
        self.tvTodayNotifications.allowsSelection = false
        
        self.tvEarlyNotifications.register(NotificationTVC.getNib(), forCellReuseIdentifier: "\(NotificationTVC.self)")
        self.tvEarlyNotifications.register(GreatNewsNotifyTVC.getNib(), forCellReuseIdentifier: "\(GreatNewsNotifyTVC.self)")
        self.tvEarlyNotifications.register(CancelEventNotificationTVC.getNib(), forCellReuseIdentifier: "\(CancelEventNotificationTVC.self)")
        self.tvTodayNotifications.register(NotificationTVC.getNib(), forCellReuseIdentifier: "\(NotificationTVC.self)")
        self.tvTodayNotifications.register(GreatNewsNotifyTVC.getNib(), forCellReuseIdentifier: "\(GreatNewsNotifyTVC.self)")
        self.tvTodayNotifications.register(CancelEventNotificationTVC.getNib(), forCellReuseIdentifier: "\(CancelEventNotificationTVC.self)")
        
        vTodayNotification.isHidden = true
        vEarlyNotification.isHidden = true
        vBodyView.isHidden = true
        
        if Defaults.imageUrl.count == 0 {
            self.lblNameCaption.text = (Defaults.firstName.count > 0 ? String(Defaults.firstName.prefix(1)) : "") + (Defaults.lastName.count > 0 ? String(Defaults.lastName.prefix(1)) : "")
            self.vNameBox.isHidden = false
        }
        
        getNotifications()
        
    }
    
    
    // MARK: - Control Actions
    @IBAction func Back_Clicked(_ sender: Any) {
        NotificationCenter.default.post(name: NotificationName.NOTIFICATION_DETECTED, object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Call API
    
}
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        
        if tableView == tvEarlyNotifications{
            print("comein earlier",earlier.count)
            return earlier.count
        }else if tableView == tvTodayNotifications{
            print("comein today",today.count)
            return today.count
        }else{
            print("return ferom 0")
            return 0
        }
        
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tvEarlyNotifications{
            let object = earlier[indexPath.row]
         //   print("123",tvEarlyNotifications.contentSize.height)
            vEarlyNotificationHeight.constant = tvEarlyNotifications.contentSize.height + 200
            
          //  print(vEarlyNotificationHeight.constant,tvEarlyNotifications.contentSize.height)
         //   print("124",vEarlyNotificationHeight.constant)
            view.layoutIfNeeded()
          //  print("row = ",indexPath.row,"last value",self.earlyCount)
            if indexPath.row == earlyCount-1{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    print("come to execute last")
                    self.vEarlyNotificationHeight.constant = self.tvEarlyNotifications.contentSize.height + 70
                }
            }
            
            switch object.type ?? ""{
            case "event":
                let cell = tableView.dequeueReusableCell(withIdentifier: "\(GreatNewsNotifyTVC.self)") as! GreatNewsNotifyTVC
                cell.configureEarlier(with: object)
          
                return cell
            case "balance_info":
               // let cell = tableView.dequeueReusableCell(withIdentifier: "\(CancelEventNotificationTVC.self)") as! CancelEventNotificationTVC
              //  cell.configureEarlier(with: object)
                let cell = tableView.dequeueReusableCell(withIdentifier: "\(GreatNewsNotifyTVC.self)") as! GreatNewsNotifyTVC
                cell.configureEarlier(with: object)
                return cell
            case "join_event":
            //    print("object type is",object.type)
                let cell = tableView.dequeueReusableCell(withIdentifier: "\(NotificationTVC.self)") as! NotificationTVC
                cell.configureEarlier(with: object)
                return cell
               
            default:
                return UITableViewCell()
            }
        }else if tableView == tvTodayNotifications{
            
                print("3333come in else")
                let object = today[indexPath.row]
                
             //   print("123",tvEarlyNotifications.contentSize.height)
                
                vTodayNotificationHeight.constant = tvTodayNotifications.contentSize.height + 200
              //  print(vEarlyNotificationHeight.constant,tvEarlyNotifications.contentSize.height)
             //   print("124",vEarlyNotificationHeight.constant)
                view.layoutIfNeeded()
              //  print("row = ",indexPath.row,"last value",self.earlyCount)
                if indexPath.row == todayCount-1{
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        print("come to execute last")
                        self.vTodayNotificationHeight.constant = self.tvTodayNotifications.contentSize.height + 70
                    }
                }
                
                switch object.type ?? ""{
                case "event":
                    print("come in event case",object.type)
                    //    print("Height of cell is",cell.contentView.)
                    let cell = tableView.dequeueReusableCell(withIdentifier: "\(GreatNewsNotifyTVC.self)") as! GreatNewsNotifyTVC
                    cell.configureToday(with: object)
              
                    return cell
                case "balance_info":
                    print("come is balance_info",object.type)
                 //   let cell = tableView.dequeueReusableCell(withIdentifier: "\(CancelEventNotificationTVC.self)") as! CancelEventNotificationTVC
                 //   cell.configureToday(with: object)
                    let cell = tableView.dequeueReusableCell(withIdentifier: "\(GreatNewsNotifyTVC.self)") as! GreatNewsNotifyTVC
                    cell.configureToday(with: object)
                    return cell
                case "join_event":
                    print("object type is",object.type)
                    let cell = tableView.dequeueReusableCell(withIdentifier: "\(NotificationTVC.self)") as! NotificationTVC
                    cell.configureToday(with: object)
                    return cell
                   
                default:
                    return UITableViewCell()
                }
        }else{
            return UITableViewCell()
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension NotificationViewController{
    
    private func getNotifications(){
        
        let call = APIManager(controller: self, headerType: .backend, parameters: nil, endPoint: .notifications, method: .post)
        startAnimating()
        call.postTest(model: NotificationModel.self) { [weak self] response in
            self?.stopAnimating()
            switch response {
            case .success(let object):
                DispatchQueue.main.async {
                    self?.vTodayNotification.isHidden = false
                    self?.vEarlyNotification.isHidden = false
                    self?.vBodyView.isHidden = false
                }
                if object.success ?? false{
                    
                    self?.earlier = object.notification?.earlier ?? []  
                 
                self?.today = object.notification?.today ?? []
                    print("notifications realy & today",self?.earlier.count,self?.today.count)
                    self?.earlyCount = self?.earlier.count ?? 0
                    self?.todayCount = self?.today.count ?? 0
                    DispatchQueue.main.async {
                        self?.lblNoEralyNotifications.isHidden = false
                        self?.lblNoTodayNotifications.isHidden = false
                        
                        if self?.earlyCount ?? 0 > 0{
                            self?.lblNoEralyNotifications.isHidden = true
                        }
                            
                        if self?.todayCount ?? 0 > 0{
                            self?.lblNoTodayNotifications.isHidden = true
                        }
                        
                        
                        self?.tvEarlyNotifications.reloadData()
                        self?.tvTodayNotifications.reloadData()
                    }
                }else{
                    
                    self?.showError(object.message)
                }
            case .failure(let error):
                print("@error",error.localizedDescription)
                self?.showError(error.localizedDescription)
            
            }
        }
    }
    
    private func showError(_ message : String?){
        Toast.show(message: message ?? "Unknown Error found", controller: self)
    }
   
    
}
