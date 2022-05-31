//
//  TabBarVC.swift
//  Coneqt.Live
//
//  Created by Senarios on 05/01/2022.
//

import UIKit
import DropDown
import SVGKit

struct EventCount: Codable{
    let data: [TypeData]
}
struct TypeData: Codable{
    let count: Int
    let title: String
    let body : Double
}


class TabBarVC: BaseViewController {
    
    @IBOutlet weak var vHeader: UIView!
    @IBOutlet weak var vNextEvent: UIView!
    @IBOutlet weak var vTopPurchaseEvents: UIView!
    @IBOutlet weak var tvEarningEvents: UITableView!
    
    @IBOutlet weak var lblNameCaption: UILabel!
    @IBOutlet weak var vNameBox: UIView!
    
    @IBOutlet weak var imgTotalRevenue: UIImageView!
    @IBOutlet weak var imgTotalEvents: UIImageView!
    @IBOutlet weak var imgTotalRefund: UIImageView!
    @IBOutlet weak var imgTotalSold: UIImageView!
    @IBOutlet weak var imgCloseNextEventView: UIImageView!
    
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var vFilter: UIView!
    
    @IBOutlet weak var imgEarningEvents: UIImageView!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var imgDownload: UIImageView!
    
    @IBOutlet weak var lblRevenueAmount: UILabel!
    
    @IBOutlet weak var btnCreateEvent: UIButton!
    
    @IBOutlet weak var vBGEarningEvents: UIView!
    @IBOutlet weak var vBGNextEvent: UIView!
    @IBOutlet weak var vDropDown: UIView!
    @IBOutlet weak var imgNextEvent: UIImageView!
    @IBOutlet weak var imgAmount: UIImageView!
    @IBOutlet weak var imgTickets: UIImageView!
    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var imgRevenue: UIImageView!

    @IBOutlet weak var lblTypeData: UILabel!
    @IBOutlet weak var lblTimeElapsed: UILabel!
    @IBOutlet weak var lblPurchaseInlastHour: UILabel!
    
    /// Analytics Outlet
    
    @IBOutlet weak var lblTotalEvents: UILabel!
    @IBOutlet weak var lblTotalRevenue: UILabel!
    @IBOutlet weak var lblTotalSoldTickets: UILabel!
    @IBOutlet weak var lblTotalRefund: UILabel!
    
    /// next event outlets
    @IBOutlet weak var imgYourNextEvent: UIImageView!
    @IBOutlet weak var lblNextEventName: UILabel!
    @IBOutlet weak var lblNextEventDate: UILabel!
    @IBOutlet weak var lblNextEventTime: UILabel!
    @IBOutlet weak var lblNextEventDescription: UILabel!
    @IBOutlet weak var lblNumberOfSoldTicket: UILabel!
    @IBOutlet weak var lblPerTicketPrice: UILabel!
    
    @IBOutlet weak var btnCancelEvent: UIButton!
    
    @IBOutlet weak var vNotification: UIView!
    var dropDown : DropDown!
    var contact = [TypeData]()
    
    var upcoming : Upcoming?{
        
        didSet{
            
            buildNextEventView()
        }
    }
    var topPurchase = [TopThree](){
        
        didSet{
            
            DispatchQueue.main.async {
                self.vTopPurchaseEvents.isHidden = false
                self.tvEarningEvents.reloadData()
            }
        }
    }
    
    
    /// Tabbar vc section start
    
    @IBOutlet weak var view1 : UIView!
    @IBOutlet weak var view2 : UIView!
    @IBOutlet weak var view3 : UIView!
    @IBOutlet weak var view4 : UIView!
    
    
    @IBOutlet weak var tabItemView: UIView!
    @IBOutlet weak var tabView: UIView!
    
    @IBOutlet weak var view1itemStack: UIStackView!
    @IBOutlet weak var view1ItemImage: UIImageView!
    
    @IBOutlet weak var view2itemStack: UIStackView!
    @IBOutlet weak var view2ItemImage: UIImageView!
    
    @IBOutlet weak var view3itemStack: UIStackView!
    @IBOutlet weak var view3ItemImage: UIImageView!
    
    @IBOutlet weak var view4itemStack: UIStackView!
    @IBOutlet weak var view4ItemImage: UIImageView!
    
    @IBOutlet weak var lblOverView : UILabel!
    @IBOutlet weak var lblEvent : UILabel!
    @IBOutlet weak var lblPayout : UILabel!
    @IBOutlet weak var lblSettings : UILabel!
    @IBOutlet weak var lblFilterStatus: UILabel!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgShare: UIImageView!
    @IBOutlet weak var vShare: UIView!
    
 
    var tabViews : [UIView]!
    var half : CGFloat!
    let customView = MyCustomView()
    var upcomingEvent : Upcoming? = nil
    
    var isViewDidLayoutSubviewsRun = false
    
    var view2ItemStackYXis : CGFloat!
    var view3ItemStackYXis : CGFloat!
    
    var historyVC : HistoryViewController!
    var payoutVC : PayoutsViewController!
    var settingsVC : SettingsViewController!
    
    @IBOutlet weak var contentView : UIView!
    
    var filterSelect = ""
    var selectFilterValue: Int = 0
    var count = 0
    var apiIndex = 4
    var isFirstTime = false
    
    /// Tabbar vc section End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        /// Tabbar vc section start
        addGesturesTabBar()
        setupUITabBar()
    
        historyVC = storyboard?.instantiateViewController(identifier: "HistoryViewController")
        payoutVC = storyboard?.instantiateViewController(identifier: "PayoutsViewController")
        settingsVC = storyboard?.instantiateViewController(identifier: "SettingsViewController")
        
        addChild(historyVC)
        addChild(payoutVC)
        addChild(settingsVC)

        self.imgShare.image = SVGKImage(named: "share").uiImage

        contentView.addSubview(historyVC.view)
        contentView.addSubview(payoutVC.view)
        contentView.addSubview(settingsVC.view)

        historyVC.didMove(toParent: self)
        payoutVC.didMove(toParent: self)
        settingsVC.didMove(toParent: self)

        historyVC.view.frame = self.contentView.bounds
        payoutVC.view.frame = self.contentView.bounds
        settingsVC.view.frame = self.contentView.bounds
        historyVC.view.isHidden = true
        payoutVC.view.isHidden = true
        settingsVC.view.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
 
            self.view1itemStack.frame.origin.y = self.view1itemStack.frame.origin.y - 10
            self.view1ItemImage.image = SVGKImage(named: "overview1").uiImage
            self.lastIndex = 1

        }
   
        /// Tabbar vc section end
        if Defaults.imageUrl.count == 0 {
            self.lblNameCaption.text = (Defaults.firstName.count > 0 ? String(Defaults.firstName.prefix(1)) : "") + (Defaults.lastName.count > 0 ? String(Defaults.lastName.prefix(1)) : "")
            self.vNameBox.isHidden = false
        }
        
        /// overview sestion start
      
         view.backgroundColor = Colors.TABBAR_BACKGROUNDS
        self.setControls()
        hitAPI()
        
        NotificationCenter.default.removeObserver(self, name: NotificationName.RELOAD_EVENT, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEventReloadCalled(_:)), name: NotificationName.RELOAD_EVENT, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NotificationName.NOTIFICATION_DETECTED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationDetected(_:)), name: NotificationName.NOTIFICATION_DETECTED, object: nil)
        
        self.getNotificationCount()
        
    }
    
    @objc func onEventReloadCalled(_ notification: Notification) {
        updateRequire()
        historyVC.updateController()
    }
    
    @objc func onNotificationDetected(_ notification: Notification) {
        
        self.getNotificationCount()
    }
    
    func updateRequire(){
        
        if Cashe.overViewScreenRefreshRequired{
            print("cASHE API Say overview require api")
            
            Cashe.overViewScreenRefreshRequired = false
        }else{
            print(" not cASHE API Say overview require api")
        }
        hitAPI()
        updateData()

        self.vNameBox.isHidden = true
        if Defaults.imageUrl.count == 0 {
            self.lblNameCaption.text = (Defaults.firstName.count > 0 ? String(Defaults.firstName.prefix(1)) : "") + (Defaults.lastName.count > 0 ? String(Defaults.lastName.prefix(1)) : "")
            self.vNameBox.isHidden = false
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customView.frame = tabView.frame
        
        view.addSubview(customView)
        view.bringSubviewToFront(tabItemView)
    }
    

    // MARK:- ACTIONS

    
    @IBAction func didTapCreateButton(_ sender: UIButton) {

        if Defaults.connectId == nil{
            Toast.show(message: Messages.noAccountFound, controller: self)
        }else if !Defaults.isConnectAccountEnable{
            Toast.show(message: Messages.noAccountEnable, controller: self)
        }else{
            let vc = ViewControllers.get(CreateEventViewController(), from: "Main")
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: false)
        }
    }
    
    @IBAction func StartEvent_Clicked(_ sender: Any) {
        
        let backendTime = self.upcomingEvent?.time!
        let backendFormatter = DateFormatter()
        backendFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        backendFormatter.timeZone = TimeZone.current
        backendFormatter.locale = Locale.current
        let backendDate = backendFormatter.date(from: backendTime!)

        let totalseconds = (backendDate!).timeIntervalSince(Date())
        if(Int(totalseconds) < 0){
            let vc = ViewControllers.get(BroadCasterVC(), from: "Stream")
            vc.event = self.upcomingEvent
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            self.showToastMessage(message: "You can't start event before Event time!")
        }
    }
    
    @IBAction func CancelEvent_Clicked(_ sender: Any) {
        
        let param = [
            "event_id": "\((self.upcomingEvent?.id)!)"
        ]
        let call = APIManager(controller: self, headerType: .backend, parameters: param, endPoint: .cancelEvent, method: .post)
          startAnimating()
        call.postTest(model: GenerelResponse.self) { [weak self] response in
            self?.stopAnimating()
            switch response{
            case .success(let object):
                print("json is",object)
                let success = object.success
                let message = object.message
                self?.hitAPI()
                self?.showToastMessage(message: message)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func Notification_Clicked(_ sender: Any) {
        let vc = ViewControllers.get(NotificationViewController(), from: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func DownloadReport_Clicked(_ sender: Any) {
        if filterSelect == "YES"{
            eventListCount(filetr: 1, stat: selectFilterValue) { response in
                self.contact = response
                self.csvCreator()
            } failure: { error in
                print(error)
            }
        }else{
            eventListCount(filetr: 0, stat: selectFilterValue) { response in
                self.contact = response
                self.csvCreator()
            } failure: { error in
                print(error)
            }
        }
        
    }
    
    @IBAction func didTapOnShare(_ sender: UIButton) {
        print("did tap on share")
        
        
        let vc = ViewControllers.get(MainPopupViewController(), from: "Main")
        vc.link = upcoming?.link?.toShow
        vc.openLink = upcoming?.link?.toOpen
        vc.onCompletion = { value in
            print("completion hadler run")
            self.dismiss(animated: true)
        }
        present(vc, animated: true)
        
//        if let upcomingEvent = upcomingEvent{
//            print(upcomingEvent.link?.toShow)
//            delegate?.shareEvent(upcomingEvent.link?.toOpen ?? "", linkToShow: upcomingEvent.link?.toShow ?? "")
//        }
        
    }
    
    
}


//MARK:- OVERVIEW VC CODE
extension TabBarVC:DelegateCreateEvent{
    
    func didCreateEvent() {
        hitAPI()
    }
    
    
    func setControls(){
        self.view.backgroundColor = Colors.SCREENS_BACKGROUND_COLOR
        tvEarningEvents.allowsSelection = false
        vNextEvent.isHidden = true
        vTopPurchaseEvents.isHidden = true
      
        self.btnCancelEvent.layer.borderWidth = 1
        self.btnCancelEvent.layer.borderColor = UIColor.black.cgColor
        
        self.vHeader.layer.cornerRadius = 80
        self.vHeader.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        
        
        self.imgNotification.image = SVGKImage(named: "notification").uiImage
        self.imgDownload.image = SVGKImage(named: "download").uiImage
        
        self.imgDropDown.image = SVGKImage(named: "dropdown_head").uiImage
        
        self.imgTotalRevenue.image = SVGKImage(named: "revenue").uiImage
        self.imgTotalEvents.image = SVGKImage(named: "total_events").uiImage
        self.imgTotalRefund.image = SVGKImage(named: "total_refund").uiImage
        self.imgTotalSold.image = SVGKImage(named: "tickets").uiImage
        
        self.imgNextEvent.image = SVGKImage(named: "hour_glass").uiImage
        self.imgAmount.image = SVGKImage(named: "amount").uiImage
        self.imgTickets.image = SVGKImage(named: "tickets").uiImage
        self.imgTime.image = SVGKImage(named: "clock").uiImage
        self.imgRevenue.image = SVGKImage(named: "revenue").uiImage
        
        self.imgCloseNextEventView.image = SVGKImage(named: "cross_black_border").uiImage
        self.imgEarningEvents.image = SVGKImage(named: "fire").uiImage
        
        
        self.vBGNextEvent.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.black, radius: 2.0, opacity: 0.4)
        self.vBGEarningEvents.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.black, radius: 2.0, opacity: 0.4)
        
        self.btnCreateEvent.layer.borderWidth = 1
        self.btnCreateEvent.layer.borderColor = UIColor.black.cgColor
        
        self.vFilter.layer.borderWidth = 1
        self.vFilter.layer.borderColor = UIColor.black.cgColor
        vFilter.isUserInteractionEnabled = true
        vFilter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFilterView)))
        
        self.vNotification.isHidden = true
        
        self.btnCreateEvent.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .bold)
        
        self.tvEarningEvents.delegate = self
        self.tvEarningEvents.dataSource = self
        self.tvEarningEvents.register(EarningEventsTVC.getNib(), forCellReuseIdentifier: "\(EarningEventsTVC.self)")
        
        /// setUp DropDown
        
        DropDown.appearance().cellHeight = 35
        
        dropDown = DropDown(anchorView: vDropDown)
        dropDown.dataSource =  ["Today","This week","This Month","This Year","All"]
        dropDown.width = 120
        
        dropDown.direction = .bottom
        dropDown.selectionAction = {index,value in
            self.apiIndex = index
            self.filterCall(index)
            self.lblFilterStatus.text = value
            if value == "Today"{
                self.selectFilterValue = 1
            }else if value == "This Week"{
                self.selectFilterValue = 2
            }else if value == "This Month"{
                self.selectFilterValue = 3
            }else if value == "This Year"{
                self.selectFilterValue = 4
            }else if value == "All"{
                self.selectFilterValue = 5
            }
            self.filterSelect = "YES"

        }
        print("overview url is",Defaults.imageUrl)
        updateData()

    }
    
    private func buildNextEventView(){

        guard let upcoming = upcoming else{
            return
        }
        
        imgYourNextEvent.sd_setImage(with: URL(string: upcoming.image1_s3 ?? ""),placeholderImage : UIImage(named: "placeholder")) { image, error, casheType, url in
         //   print("image",image)
         //   print("error",error)
         //   print("cashe",casheType)
         //   print("url",url)
        }

        let dateAndTime = upcoming.time?.convertToProjectFormat()

        lblNextEventName.text = upcoming.name
       // lblNextEventDate.text = dateAndTime?.0
       // let duration = upcoming.time_duration ?? 0
        lblNextEventTime.text = "" // String(upcoming.time_duration ?? 0)
        lblPerTicketPrice.text = "£"+String(upcoming.ticket_price ?? 0)
        lblNextEventDescription.text = upcoming.description
        lblNumberOfSoldTicket.text = String(upcoming.event_payments_and_verification_count ?? 0)
        vNextEvent.isHidden = false
    }
    
    //MARK:- @OBJC FUNC
    @objc func didTapFilterView(){
        print("did tap filter view ")
        dropDown.show()
    }
}

extension TabBarVC {
    
    /// ALL APIS CALLINGS
    /// Main Overview API
    private func hitAPI(){
        
        let apiService = APIManager(controller: self, headerType: .backend, endPoint: .overview, method: .get)
        if (!isFirstTime){
            isFirstTime = true
            startAnimating()
        }
        
        apiService.postTest(model: OverViewModel.self) {[weak self] response in
            
            defer{ self?.stopAnimating() }
            
            switch response{
            case .success(let overView):
                
                DispatchQueue.main.async {
                    self?.handleResponse(object: overView)
                }
                
            case .failure(let error):
                self?.showToastMessage(message: error.errorDescription)
                print("hitAPI tabbarVC 403", error.errorDescription)
            }
        }
    }
    
    private func handleResponse(object : OverViewModel){
       
        topPurchase = object.overView?.topThree ?? []
        upcoming = object.overView?.upcoming?.first
        
        self.upcomingEvent = object.overView?.upcoming?.first
        
        let totalEvents = String(object.overView?.total_events ?? 0)
        let totalRevenue = "£"+String(object.overView?.revenue ?? 0)
        let totalSoldTickets = String(object.overView?.tickets ?? 0)
        let totalRefund = "£"+String(object.overView?.refunds ?? 0)
        
        Cashe.totalEvents = totalEvents
        Cashe.totalRevenue = totalRevenue
        Cashe.totalRefund = totalRefund
        Cashe.totalSoldTickets = totalSoldTickets
        
        lblTotalEvents.text = totalEvents
        lblTotalRevenue.text = totalRevenue
        lblTotalSoldTickets.text = totalSoldTickets
        lblTotalRefund.text = totalRefund
        
        if (upcoming != nil){
            lblTypeData.text = upcoming?.type
            lblTimeElapsed.text = upcoming?.time
            lblRevenueAmount.text = "£"+String(upcoming?.totalEventRevenue ?? 0.0)
            
            let dateAndTime = upcoming?.time?.convertToEventFormat()
            let elapsedTime = upcoming?.time?.getCurrentTimeDifference()
            let lTotalMinutes = ((upcoming?.time_duration!)!) / 60
            let lHours = lTotalMinutes / 60
            let lMinutes = lTotalMinutes % 60
          
            var NewTime = ""
            if(lHours > 0){
                NewTime = "\(lHours)h "
            }
            if(lMinutes > 0){
                NewTime += "\(lMinutes)min"
            }
              
            lblNextEventDate.text = "Time: \(dateAndTime?.1 ?? "") \(dateAndTime?.0 ?? "") | \(NewTime)"
            lblTimeElapsed.text = elapsedTime
            lblPurchaseInlastHour.text = "\((upcoming?.lastHourTicketPurchased!)!)"
            vNextEvent.isHidden = false
        }
        else
        {
            vNextEvent.isHidden = true
        }
        /// Make startupCall
        startupCall()
    }
    /// Filter the stats on different bases
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
    
    private func startupCall(){
        guard
            let url = URL(string: "https://conneqt.senarios.co/api/event/type") else {return}
        
        let apiService = APIManager(headerType: .none, url: url, method: .get)
        apiService.getModel(model: FilterModel.self) { response in
            switch response{
            case .success(let model):
                Cashe.filterModel = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func getNotificationCount(){
        guard let url = Methods.shared.stringToUrl(APIEndPoints.getNotificationCount) else{
            print("fail to get url")
            return
        }
        let api = APIManager(headerType: .backend, url: url)
        
        api.getModel(model: NotificationCountResponse.self) { [weak self] response in
           
            switch response{
                
            case .success(let notificationCount):
                if (notificationCount.success){
                    print("getNotificationCount Data",notificationCount.count)
                    Cashe.notificationCount = notificationCount.count
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.updateNotificationDot()
                        self?.historyVC.updateNotificationDot()
                        self?.payoutVC.updateNotificationDot()
                        self?.settingsVC.updateNotificationDot()
                    }
                }
                else
                {
                    print("getNotificationCount Fail Data", notificationCount.count)
                }
            case .failure(let error):
                
                print("Fail to get the Count",error.localizedDescription)
            }
        }
    }
    
    //MARK: CSV Creator
   func csvCreator(){

     
       var fileName = "ConeqtLive_\(Date().currentTimeMillis()).csv"
       let documentDirectryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
       let documentURL = URL(fileURLWithPath: documentDirectryPath).appendingPathComponent(fileName)
       
       
       if documentURL.checkFileExist(){
           print("yes")
           count = (count + 1)
           print(documentURL.lastPathComponent)
           fileName = "coneqtLive\(count).csv"
           print(fileName)
       }else{
           fileName = "coneqtLive.csv"
       }

       print(fileName)
       let outpout = OutputStream.toMemory()
       let csvWriter = CHCSVWriter(outputStream: outpout, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
      //MARK: Array TO Add Data
       
       for (elements) in contact{
           csvWriter?.writeField(elements.count)
           csvWriter?.writeField(elements.title)
           csvWriter?.writeField(elements.body)

           csvWriter?.finishLine()

       }
//        csvWriter?.closeStream()
       let buffer = (outpout.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)
       do{
           try buffer?.write(to: documentURL)
           self.showToastMessage(message: "File has been downloaded ... Please check downloads")
       }catch{
           print("nothing happened")
       }

   }
    
    //MARK: CSV File Data
    func eventListCount(filetr: Int,stat: Int, success: @escaping([TypeData])->(), failure: @escaping(String)->()){
        let param = [
            "stat": stat,
            "filter": filetr
        ]
        
        
        let url  = URL(string: "https://conneqt.senarios.co/content_creator/export/overview/Api")!
        print(url)
        let object = APIManager(headerType: .backend, parameters: param, url: url)
        object.post(model: EventCount.self) { [weak self] response in
            print(response)
            switch response{
            case .success(let overviews):
                print("overview count is",overviews)
                DispatchQueue.main.async {
                    success(overviews.data)
                    self?.stopAnimating()
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}


extension TabBarVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topPurchase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(EarningEventsTVC.self)") as! EarningEventsTVC
        cell.purchaseObject = topPurchase[indexPath.row]
        print(cell.lblName.text, cell.lblNumberOfTickets.text)
        return cell
    }
}







//MARK:- TABBAR VC CODE
extension TabBarVC {
    
    
    
    
    private func setupUITabBar(){
        
        
        view4ItemImage.image = SVGKImage(named: "setting").uiImage
        view3ItemImage.image = SVGKImage(named: "payout").uiImage
        view2ItemImage.image = SVGKImage(named: "event").uiImage
        
        lblOverView.font = Fonts.get(type: .Montserrat_Bold, size: 10)
        lblEvent.font = Fonts.get(type: .Montserrat_Bold, size: 10)
        lblPayout.font = Fonts.get(type: .Montserrat_Bold, size: 10)
        lblSettings.font = Fonts.get(type: .Montserrat_Bold, size: 10)
    }
    
    private func addGesturesTabBar(){
        
        view1.isUserInteractionEnabled = true
        view1.tag = 1
        view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView1)))
        
        view2.isUserInteractionEnabled = true
        view2.tag = 2
        view2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView2)))
        
        view3.isUserInteractionEnabled = true
        view3.tag = 3
        view3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView3)))
        
        view4.isUserInteractionEnabled = true
        view4.tag = 4
        view4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView4)))
        
    }
  

    
    
    @objc func didTapView1(){
        
        
        updateView(tag: 1)
        
        
    }
    
    @objc func didTapView2(){
        
        updateView(tag: 2)
      
    }
    
    @objc func didTapView3(){
        
        updateView(tag: 3)
    }

    @objc func didTapView4(){
        
        updateView(tag: 4)
    }

    
    
    private func updateView(tag : Int){

        let i3 = self.view.getConvertedFrame(fromSubview: view3ItemImage)
        let i2 = self.view.getConvertedFrame(fromSubview: view2ItemImage)
        let i1 = self.view.getConvertedFrame(fromSubview: view1ItemImage)
        let i4 = self.view.getConvertedFrame(fromSubview: view4ItemImage)
        
        updateLastIndexYXis()
        historyVC.view.isHidden = true
        settingsVC.view.isHidden = true
        payoutVC.view.isHidden = true
        
        switch tag {
        case 1:
          

            lastIndex = 1
            view1ItemImage.image = UIImage(named: "overview1")
            view1itemStack.frame.origin.y = view1itemStack.frame.origin.y - 10
            self.customView.moveShape(CGPoint(x: i1!.origin.x - 25, y: 0))
            updateRequire()
           
        case 2:
            historyVC.view.isHidden = false
            historyVC.updateData()
            historyVC.updateController()
            lastIndex = 2
            view2ItemImage.image = SVGKImage(named: "event1").uiImage
            view2itemStack.frame.origin.y = view2itemStack.frame.origin.y - 10
            self.customView.moveShape(CGPoint(x: i2!.origin.x - 30, y: 0))
            
        case 3:
            

            payoutVC.view.isHidden = false
            payoutVC.setup()
            lastIndex = 3
            view3ItemImage.image = SVGKImage(named: "payout1").uiImage
            view3itemStack.frame.origin.y = view3itemStack.frame.origin.y - 10
            self.customView.moveShape(CGPoint(x: i3!.origin.x - 30 , y: 0))
            
        default:
            

            settingsVC.view.isHidden = false
            settingsVC.update()
            lastIndex = 4
            view4ItemImage.image = SVGKImage(named: "setting1").uiImage
            view4itemStack.frame.origin.y = view4itemStack.frame.origin.y - 10
            self.customView.moveShape(CGPoint(x: i4!.origin.x - 30 , y: 0))
            
        }
        
        
        
        
    }
    
    
    private func updateLastIndexYXis(){
      
        switch lastIndex {

        case 1:
            view1itemStack.frame.origin.y = view1itemStack.frame.origin.y + 10
            view1ItemImage.image = SVGKImage(named: "overview").uiImage
        case 2:
            view2itemStack.frame.origin.y = view2itemStack.frame.origin.y + 10
            view2ItemImage.image = SVGKImage(named: "event").uiImage
        case 3:
            view3ItemImage.image = SVGKImage(named: "payout").uiImage
            view3itemStack.frame.origin.y = view3itemStack.frame.origin.y + 10
        case 4:
            view4ItemImage.image = SVGKImage(named: "setting").uiImage
            view4itemStack.frame.origin.y = view4itemStack.frame.origin.y + 10
        default:
            return
        }
    }
    
    
}
extension UIView {

    // there can be other views between `subview` and `self`
    func getConvertedFrame(fromSubview subview: UIView) -> CGRect? {
        // check if `subview` is a subview of self
        guard subview.isDescendant(of: self) else {
            return nil
        }
        
        var frame = subview.frame
        if subview.superview == nil {
            return frame
        }
        
        var superview = subview.superview
        while superview != self {
            frame = superview!.convert(frame, to: superview!.superview)
            if superview!.superview == nil {
                break
            } else {
                superview = superview!.superview
            }
        }
        
        return superview!.convert(frame, to: self)
    }

}


