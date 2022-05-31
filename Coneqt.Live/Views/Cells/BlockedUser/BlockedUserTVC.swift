//
//  BlockedUserTVC.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/30/21.
//

import UIKit

class BlockedUserTVC: UITableViewCell {
    
    var unblockTapCallback: () -> ()  = { }

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnUnblock: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var vShowNameImage: UIView!
    @IBOutlet weak var lblShowName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnUnblock.layer.borderWidth = 1
        self.btnUnblock.layer.borderColor = UIColor.black.cgColor
        self.btnUnblock.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .bold)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func unblock_Clicked(_ sender: Any) {
        unblockTapCallback()
    }
    
    static func getNib() -> UINib{
        return UINib(nibName: "\(BlockedUserTVC.self)", bundle: nil)
    }
    
}
