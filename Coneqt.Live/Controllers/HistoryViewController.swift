//
//  HistoryViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/27/21.
//

import UIKit
import Foundation

enum EventTime{
    
    case upcoming
    case past
}


class HistoryViewController: BaseViewController {
    
    var refreshControl   = UIRefreshControl()
    
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var lblNameCaption: UILabel!
    @IBOutlet weak var vNameBox: UIView!
    
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var vMessageArea: UIView!
    @IBOutlet weak var imgBubble: UIImageView!
    @IBOutlet weak var vMessageBubble: UIView!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var segmentHistory: UISegmentedControl!
    @IBOutlet weak var lblNoEvent: UILabel!
    @IBOutlet weak var tvHistoryList: UITableView!
    
    @IBOutlet weak var vNotification: UIView!
    var upcomingEvent = [Upcoming]()
    var pastEvent = [Past]()
    var eventTime : EventTime = .upcoming
    
    var isRefreshEnable = false
    var tabSelectedIndex = 0
    
    var eventsTimer : Timer?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.TABBAR_BACKGROUNDS
        self.setControls()
       
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tvHistoryList.addSubview(refreshControl)
     //   refreshControl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
     
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    
    // MARK: - Class Functions
    func setControls(){
       // self.view.backgroundColor = Colors.SCREENS_BACKGROUND_COLOR
        getEvents()
        self.vHeader.layer.cornerRadius = 80
        self.vHeader.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        
        self.segmentHistory.tintColor = Colors.MAIN_BACKGROUND_COLOR //background
        self.segmentHistory.backgroundColor = UIColor.white
        
        self.vMessageBubble.isHidden = true
        
        //self.segmentHistory.selectedSegmentTintColor = UIColor.redColor;
        self.segmentHistory.layer.backgroundColor = UIColor.white.cgColor;
        
        let fontName = UIFont(name:"Montserrat-Bold", size:10)
        
        self.segmentHistory.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: fontName ], for: .selected)
        self.segmentHistory.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.MAIN_BACKGROUND_COLOR, NSAttributedString.Key.font: fontName], for: .normal)
        self.segmentHistory.layer.borderColor = Colors.MAIN_BACKGROUND_COLOR.cgColor
        self.segmentHistory.layer.borderWidth = 1
        
        self.vMessageArea.layer.borderColor = Colors.ERROR_BLUE_BG.cgColor
        self.vMessageArea.layer.borderWidth = 1
        
        self.vNotification.isHidden = true
        
        let backGroundImage = UIImage(color: .black, size: CGSize(width: 1, height: 32))
        let clearbackGroundImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
        self.segmentHistory.setBackgroundImage(clearbackGroundImage, for: .normal, barMetrics: .default)
        self.segmentHistory.setBackgroundImage(backGroundImage, for: .selected, barMetrics: .default)
        
        
        self.imgNotification.image = SVGKImage(named: "notification").uiImage
        self.imgBubble.image = SVGKImage(named: "blue_alert").uiImage
        
        self.tvHistoryList.delegate = self
        self.tvHistoryList.dataSource = self
        self.tvHistoryList.register(HistoryTVC.getNib(), forCellReuseIdentifier: "\(HistoryTVC.self)")
        tvHistoryList.allowsSelection = false
        lblNoEvent.font = Fonts.get(type: .Montserrat_Semibold, size: 15)
        lblNoEvent.text = "There is no event found"
        lblNoEvent.isHidden = true
        if Defaults.imageUrl.count == 0 {
            self.lblNameCaption.text = (Defaults.firstName.count > 0 ? String(Defaults.firstName.prefix(1)) : "") + (Defaults.lastName.count > 0 ? String(Defaults.lastName.prefix(1)) : "")
            self.vNameBox.isHidden = false
        }
        StartEventsTimer()
        
        
        
    }
    
    func updateController(){
        self.segmentHistory.selectedSegmentIndex = 0
        self.SelectHistoryData(selectedIndex: 0)
        self.vNameBox.isHidden = true
        if Defaults.imageUrl.count == 0 {
            self.lblNameCaption.text = (Defaults.firstName.count > 0 ? String(Defaults.firstName.prefix(1)) : "") + (Defaults.lastName.count > 0 ? String(Defaults.lastName.prefix(1)) : "")
            self.vNameBox.isHidden = false
        }
        self.isRefreshEnable = true
        self.getEvents()
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
    
    func StartEventsTimer() {
      guard eventsTimer == nil else { return }

        eventsTimer = Timer.scheduledTimer(timeInterval: 60.0,
                                         target: self,
                                         selector: #selector(RefreshEventsData),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    func StopEventsTimer() {
        eventsTimer?.invalidate()
        eventsTimer = nil
    }
    
    @objc func RefreshEventsData() {
        self.tvHistoryList.reloadData()
    }
    
    // MARK: - Control Actions
    
    @IBAction func didChangeHistorySelection(_ sender: UISegmentedControl) {
//        if sender.selectedSegmentIndex == 0{
//
//        }else{
//
//        }
        self.lblNoEvent.isHidden = true
        self.tabSelectedIndex = sender.selectedSegmentIndex
        self.SelectHistoryData(selectedIndex: self.tabSelectedIndex)
        
    }
    
    func SelectHistoryData(selectedIndex: Int){
        if(selectedIndex == 0){
            eventTime = .upcoming
            lblNoEvent.isHidden =  self.upcomingEvent.count == 0 ? false : true
        }
        else
        {
            eventTime = .past
            lblNoEvent.isHidden =  self.pastEvent.count == 0 ? false : true
        }
        tvHistoryList.reloadData()
    }
    
    @IBAction func Notification_Clicked(_ sender: Any) {
        let vc = ViewControllers.get(NotificationViewController(), from: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Call API
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource, HistoryDelegate{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        switch eventTime{
            
        case .upcoming:
            return upcomingEvent.count
        case .past:
            return pastEvent.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(HistoryTVC.self)") as! HistoryTVC
        cell.vBGShadow.addShadow(offset: CGSize.init(width: 0, height: 0.3), color: UIColor.black, radius: 1.5, opacity: 0.2)
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
        
        
        switch eventTime{
        case .upcoming:
            let event = upcomingEvent[indexPath.row]
            cell.upcomingEvent = event
            cell.delegate = self
        case .past:
            let event = pastEvent[indexPath.row]
            cell.pastEvent = event
            cell.delegate = self
        }
        cell.index = indexPath.row
        return cell
    }
    

    
    func StartEvent(_ event : Upcoming){
        
        let backendTime = event.time!
        let backendFormatter = DateFormatter()
        backendFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        backendFormatter.timeZone = TimeZone.current
        backendFormatter.locale = Locale.current
        let backendDate = backendFormatter.date(from: backendTime)

        let totalseconds = (backendDate!).timeIntervalSince(Date())
        if(Int(totalseconds) < 0){
            let vc = ViewControllers.get(BroadCasterVC(), from: "Stream")
            vc.event = event
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            self.showToastMessage(message: "You can't start event before Event time!")
        }
    }
    
    func CancelEvent( _ index: Int){
        let cancelData = self.upcomingEvent[index]
        self.lblErrorMessage.text = "Event “\(cancelData.name!)” was canceled"
        // Event “Morning Meditation & Yoga” was canceled
        self.vMessageBubble.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
            self.vMessageBubble.isHidden = true
        }
        
        let url  = URL(string: "\(APIEndPoints.cancelEvent)")!
        let param = [
            "event_id": "\(cancelData.id!)"
        ] // GenerelResponse
       // let call = APIManager(headerType: .none,parameters: param, url: url)
        let call = APIManager(controller: self, headerType: .backend, parameters: param, endPoint: .cancelEvent, method: .post)
          startAnimating()
        call.postTest(model: GenerelResponse.self) { [weak self] response in
            self?.stopAnimating()
            switch response{
            case .success(let object):
                print("json is",object)
                let success = object.success
                let message = object.message
                self?.getEvents()
                self?.showToastMessage(message: message)
                    
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        

    }
    
    func shareEvent(_ linkToOpen : String, linkToShow : String){
        let vc = ViewControllers.get(MainPopupViewController(), from: "Main")
        vc.link = linkToShow
        vc.openLink = linkToOpen
        vc.onCompletion = { value in
            print("completion hadler run")
            self.dismiss(animated: true)
        }
        present(vc, animated: true)
    }
    
//    func shareEvent(_ text: String) {
//        let shareText = text
//        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
//        present(vc, animated: true)
//    }
}




extension HistoryViewController{
    
    public func getEvents(){
    
        guard let url = Methods.shared.stringToUrl(APIEndPoints.getUserEvents) else{
            print("fail to get url")
            return
        }
        let api = APIManager(headerType: .backend, url: url)
        if !isRefreshEnable{
            startAnimating()
        }
        api.getModel(model: EventHistoryModel.self) { [weak self] response in
            self?.stopAnimating()
            self?.refreshControl.endRefreshing()
            self?.isRefreshEnable = false
            switch response{
                
            case .success(let history):
                self?.pastEvent = history.eventHistory?.past ?? []
                self?.upcomingEvent = history.eventHistory?.upcoming ?? []
                print("First Event",self?.upcomingEvent.first)
                if self?.tabSelectedIndex == 0 {
                    self?.lblNoEvent.isHidden = self?.upcomingEvent.count == 0 ? false : true
                }
                if self?.tabSelectedIndex == 1 {
                    self?.lblNoEvent.isHidden = self?.pastEvent.count == 0 ? false : true
                }
                
                self?.tvHistoryList.reloadData()
            case .failure(let error):
                Toast.show(message: error.localizedDescription, controller: self!)
                print("Fail to get the event history",error.localizedDescription)
            }
        }
        
    }
    
    
    @objc func refresh(_ sender: Any) {
        print("refresh get api call")
        isRefreshEnable = true
            getEvents()
            self.refreshControl.endRefreshing()
        }
}






extension UIImage {

convenience init?(color: UIColor, size: CGSize) {
    UIGraphicsBeginImageContextWithOptions(size, false, 1)
    color.set()
    guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
    ctx.fill(CGRect(origin: .zero, size: size))
    guard
        let image = UIGraphicsGetImageFromCurrentImageContext(),
        let imagePNGData = image.pngData()
        else { return nil }
    UIGraphicsEndImageContext()

    self.init(data: imagePNGData)
   }
}


extension UISegmentedControl {

func fallBackToPreIOS13Layout(using tintColor: UIColor) {
    if #available(iOS 13, *) {
        let backGroundImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
        let dividerImage = UIImage(color: tintColor, size: CGSize(width: 1, height: 32))

        setBackgroundImage(backGroundImage, for: .normal, barMetrics: .default)
        setBackgroundImage(dividerImage, for: .selected, barMetrics: .default)

        setDividerImage(dividerImage,
                        forLeftSegmentState: .normal,
                        rightSegmentState: .normal, barMetrics: .default)

        layer.borderWidth = 1
        layer.borderColor = tintColor.cgColor

        setTitleTextAttributes([.foregroundColor: tintColor], for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    } else {
        self.tintColor = tintColor
    }
  }
}



