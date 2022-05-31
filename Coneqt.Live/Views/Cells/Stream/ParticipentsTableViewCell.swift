//
//  ParticipentsTableViewCell.swift
//  Coneqt.LiveViewers
//
//  Created by Zain Ahmed on 16/12/2021.
//

import UIKit

//
//  ParticipentsTableViewCell.swift
//  Coneqt.LiveViewers
//
//  Created by Zain Ahmed on 16/12/2021.
//


protocol DelegateParticipentsVC{
    func didTapKickout(_ id : String)
    func didTapBlock(_ id : String, userName : String)
}


class ParticipentsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblNameOption: UILabel!
    @IBOutlet weak var vNameCover: UIView!
    @IBOutlet weak var imageViewUser : UIImageView!
    @IBOutlet weak var lblName : UILabel!
//    @IBOutlet weak var lblTag : UILabel!
    @IBOutlet weak var btnBlock : UIButton!
    @IBOutlet weak var btnKickout : UIButton!
    
    @IBOutlet weak var lblKickout: UILabel!
    @IBOutlet weak var lblBlock: UILabel!
    
    
    var delegate : DelegateParticipentsVC?
    
    var user : StreamParticipent!{
        
        didSet{
            
           setup()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewUser.image = UIImage(named: "zain")
        imageViewUser.layer.cornerRadius = imageViewUser.frame.height / 2
        imageViewUser.clipsToBounds = true

        lblName.font = Fonts.get(type: .Montserrat_Bold, size: 14)
    //    lblTag.font = Fonts.get(type: .Montserrat_Regular, size: 12)
     //   lblTag.textColor = UIColor(red: 0.654, green: 0.654, blue: 0.654, alpha: 1)
      
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func setup(){
        btnBlock.titleLabel?.font = Fonts.get(type: .Montserrat_Bold, size: 12)
        btnKickout.titleLabel?.font = Fonts.get(type: .Montserrat_Bold, size: 12)
        guard let user = user else {
            return
        }

        imageViewUser.sd_setImage(with: URL(string: user.image), placeholderImage : UIImage(named: "profilePlaceholder"))
        lblName.text = user.name
      //  lblTag.text = "@"+user.name
        self.vNameCover.isHidden = true
        if(user.image == nil || user.image.count == 0){
            self.vNameCover.isHidden = false
            let selectedName = ((user.name.count) > 0 ? String((user.name.prefix(1))).uppercased() : "")
            self.lblNameOption.text = selectedName
        }
        
    }
    
    static func getNib() -> UINib{
        
        return UINib(nibName: "\(ParticipentsTableViewCell.self)", bundle: nil)
    }
    
    @IBAction func didTapKickOut(_ sender: UIButton) {
        print("user id",user.id)
        delegate?.didTapKickout(user.id)
    }
    
    @IBAction func didTapBlockUser(_ sender: UIButton) {
        print("user id",user.id)
        delegate?.didTapBlock(user.id, userName: user.name)
    }
}
