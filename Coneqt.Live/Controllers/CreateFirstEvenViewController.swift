//
//  CreateFirstEvenViewController.swift
//  Coneqt.Live
//
//  Created by Azhar on 12/27/21.
//

import UIKit
import Foundation

class CreateFirstEvenViewController: UIViewController {
    
    @IBOutlet weak var btnCreateEvent: UIButton!
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setControls()
    }
    
    // MARK: - Class Functions
    func setControls(){
       // self.view.backgroundColor = Colors.SCREENS_BACKGROUND_COLOR
        
        self.btnCreateEvent.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .bold)
       
    }
    
    
    // MARK: - Control Actions
    
    @IBAction func CreateEvent_Clicked(_ sender: Any) {
       // self.performSegue(withIdentifier: Segues.FirstEvent_To_CreateEvent, sender: self)
        let vc = ViewControllers.get(TabBarVC(), from: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Call API
    
}

