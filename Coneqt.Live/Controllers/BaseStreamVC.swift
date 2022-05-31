//
//  BaseStreamVC.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 25/11/2021.
//

import UIKit
import AgoraRtcKit

class BaseStreamVC: UIViewController {

    
    
    @IBOutlet weak var lblCallback : UILabel!
    @IBOutlet weak var lblViewers : UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var heartView: UIView!
    @IBOutlet weak var thumbView: UIView!
    @IBOutlet weak var streamTitleView : UIStackView!

    @IBOutlet weak var imgExpand: UIImageView!
    
    var agoraKit: AgoraRtcEngineKit?
    
    var messages = [StreamMessage]()
    var fStreamId = ""
    var messageDeleteTimer : Timer!
    
    /// Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("sucessfully clear in view did disappaer")
        
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }

    
    func setupUI(){
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(StreamTableViewCell.nib(), forCellReuseIdentifier: "\(StreamTableViewCell.self)")
        tableView.allowsSelection = false
        
        heartView.layer.cornerRadius = heartView.frame.height/2
        thumbView.layer.cornerRadius = heartView.frame.height/2
     
        heartView.isUserInteractionEnabled = true
        thumbView.isUserInteractionEnabled = true
       
    //    imgDismiss.isUserInteractionEnabled = true
        
        messageDeleteTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        navigationItem.largeTitleDisplayMode = .never

        imgExpand.image = SVGKImage(named: "expand").uiImage
        imgExpand.isUserInteractionEnabled = true
        imgExpand.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapExpandBtn)))
    }
    
    
    @objc private func fireTimer(){


        
        if messages.count > 0{
            let indexPath = IndexPath(row: 0, section: 0)

                DispatchQueue.main.asyncAfter(deadline: .now()+1) {

                    let cell = self.tableView.cellForRow(at: indexPath)
                    cell?.alpha = 0.6

                }

            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                let cell = self.tableView.cellForRow(at: indexPath)
                cell?.alpha = 0.3

                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    print("@@delete successfully")
                    self.messages.remove(at: 0)
                    self.tableView.deleteRows(at: [indexPath], with: .right)
                }

            }
        }

    }
    
    
    func generateAnimation(type :  AnimationImage,url : String, userName: String){
        
        let heart = UIImageView(image: SVGKImage(named: "heart").uiImage)
        let person = UIImageView(image: UIImage(named: "zain"))
        let thumb = UIImageView(image: UIImage(systemName: "hand.thumbsup.circle.fill"))
        
        
        var imageView : UIImageView!
        let personView = UIView()
        
        switch type {
        case .person:
            imageView = person
            
        case .heart:
            imageView = heart
            imageView.tintColor = .red
        case .thumb:
            imageView = thumb
        }
        var dimension : Double!
        dimension = 30 + drand48() * 1.5
        if type == .person{
            dimension = 30
        }

        imageView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        personView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        
        if type == .person{
           // print("come in person image view",imageView.frame.height)
            print("url before generate recation")
            if(url.count > 0){
                imageView.sd_setImage(with: URL(string: url),placeholderImage : UIImage(named: "profilePlaceholder"))
                imageView.layer.borderWidth = 1
                imageView.layer.masksToBounds = false
                imageView.layer.borderColor = UIColor.white.cgColor
                imageView.layer.cornerRadius = imageView.frame.height/2
                imageView.contentMode = .scaleAspectFill
                //This will change with corners of image and height/2 will make this circle shape
                imageView.clipsToBounds = true
            }
            else
            {
                personView.layer.borderWidth = 1
                personView.layer.masksToBounds = false
                personView.layer.borderColor = UIColor(red: 141/255, green: 198/255, blue: 253/255, alpha: 1.0).cgColor
                personView.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 253/255, alpha: 1.0)
                personView.layer.cornerRadius = personView.frame.height/2
                personView.clipsToBounds = true
                
                let nameLetter = (userName.count > 0 ? String(userName.prefix(1)) : "")
                let lblName = UILabel(frame: CGRect(x: 0, y: 0, width: personView.frame.height, height: personView.frame.height))
                lblName.center = CGPoint(x: personView.frame.height/2, y: personView.frame.height/2)
                lblName.text = nameLetter.uppercased()
                lblName.textAlignment = .center //For center alignment
                lblName.textColor = .white
                lblName.backgroundColor = .clear
                lblName.numberOfLines = 1
                lblName.font = UIFont(name: "Montserrat-Bold", size: 14)
                personView.addSubview(lblName)
            }
        }
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        let object = Animations.shared

        let bazerPath = drand48() > 0.5 ?  object.customPath1().cgPath : object.customPath().cgPath
        animation.path = bazerPath
        let duration = 2 + drand48() * 10
        animation.duration = duration
        
        // remove animation object
        animation.fillMode = .removed
        animation.isRemovedOnCompletion = false
        
        // make fast at begining
        if type == .person{
            animation.timingFunction = CAMediaTimingFunction(name: .default)
        }else{
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        }
        if type == .person && url.count == 0{
            personView.layer.add(animation, forKey: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4){
                personView.alpha = 0.7
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                    personView.alpha = 0.4
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4){
                        personView.alpha = 0
                    }
                }
                
            }

            view.addSubview(personView)
        }
        else
        {
            imageView.layer.add(animation, forKey: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4){
                imageView.alpha = 0.7
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                    imageView.alpha = 0.4
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4){
                        imageView.alpha = 0
                    }
                }
                
            }

            view.addSubview(imageView)
        }
    }
    
    func dismiss(){
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc func didTapExpandBtn(){
        
        if streamTitleView.isHidden{
            streamTitleView.isHidden = false
            imgExpand.image = SVGKImage(named: "expand").uiImage
        }else{
            streamTitleView.isHidden = true
            imgExpand.image = SVGKImage(named: "expand_up").uiImage
        }
        
        
    }

}
