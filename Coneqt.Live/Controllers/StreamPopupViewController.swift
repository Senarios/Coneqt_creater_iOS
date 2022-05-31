//
//  StreamPopupViewController.swift
//  Coneqt.Live
//
//  Created by Senarios on 18/01/2022.
//

import UIKit

class StreamPopupViewController: UIViewController {

    
    /// Event End Popup References
     @IBOutlet weak var endStreamPopUpView : UIView!
     @IBOutlet weak var btnCancel : UIButton!
     
    var endNow : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCancel.layer.borderColor = UIColor.black.cgColor
        btnCancel.layer.borderWidth = 1
       
    }
    

   
    @IBAction func didTapEndNow(_ sender: Any) {
        dismiss(animated: false)
        endNow!()
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
}
