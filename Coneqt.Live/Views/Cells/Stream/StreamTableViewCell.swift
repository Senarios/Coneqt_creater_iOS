//
//  StreamTableViewCell.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 01/12/2021.
//

import UIKit
import DropDown
import SDWebImage

class StreamTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage : UIImageView!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var time : UILabel!
    @IBOutlet weak var message : UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var dropDownView: UIView!
    
    @IBOutlet weak var lblNameOption: UILabel!
    @IBOutlet weak var vNameBlock: UIView!
    
    var dropDown : DropDown!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        
        
        message.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        name.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        time.textColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        
        message.font = Fonts.get(type: .Montserrat_Regular, size: 14)
        name.font = Fonts.get(type: .Montserrat_Bold, size: 14)
        time.font = Fonts.get(type: .Montserrat_Regular, size: 11)
     
        
       // btnMenu.setImage(SVGKImage(named: "image").uiImage, for: .normal)
        btnMenu.setImage(SVGKImage(named: "menu").uiImage, for: .normal)
        /// setUp DropDown
        
        dropDown = DropDown(anchorView: dropDownView)
        dropDown.dataSource =  ["Block","Kickout"]
        dropDown.width = 120
        dropDown.selectionAction = {index,value in
            print(index,value)
            
            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib{
        
        return UINib(nibName: "\(StreamTableViewCell.self)", bundle: nil)
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        print("did tap Menu")
      //  dropDown.show()
    }
}
