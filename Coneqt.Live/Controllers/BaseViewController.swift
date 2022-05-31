//
//  BaseViewController.swift
//  Coneqt.Live
//
//  Created by Senarios on 02/02/2022.
//

import UIKit

class BaseViewController: UIViewController {

    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNickName: UILabel!
    
    var spinner = Spinner()
    var lastIndex = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(spinner)
        
        if imgProfile != nil{
            print(Defaults.imageUrl)
            imgProfile.sd_setImage(with: URL(string: Defaults.imageUrl), placeholderImage: UIImage(named: "profilePlaceholder"))
            lblName.text = Defaults.firstName
            lblNickName.text = "@"+Defaults.firstName+"_"+Defaults.lastName
            imgProfile.round()
        
        }
     
    }
    
    
     func updateData(){
        imgProfile.sd_setImage(with: URL(string: Defaults.imageUrl), placeholderImage: UIImage(named: "profilePlaceholder"))
        lblName.text = Defaults.firstName
        lblNickName.text = "@"+Defaults.firstName+"_"+Defaults.lastName
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //  spinner.frame = CGRect(x: (UIScreen.width/2) - 30, y: UIScreen.height/2-30, width: 60, height: 60)
          spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
    }
    
    func startAnimating(){
        spinner.startAnimating()
    }
    
    func stopAnimating(){
        spinner.stopAnimating()
    }
    
    func dismissVC(){
        dismiss(animated: true)
    }
    
    func showToastMessage(message : String){
        
        Toast.show(message: message, controller: self)
    }
}
