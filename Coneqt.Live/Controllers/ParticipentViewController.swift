

import UIKit
import FirebaseDatabase
import SwiftUI



protocol DismissControllerDelegate{
    
    func didDismissController()
}


class ParticipentViewController : BaseViewController {


    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var imgViewers: UIImageView!
    @IBOutlet weak var txtViewers: UILabel!
    @IBOutlet weak var btnDismissController: UIButton!
    var delegeate : DismissControllerDelegate?
    var eventId : Int!

    var participents = [StreamParticipent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
    }
    
    private func setupUI(){
        
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        
        self.imgViewers.image = SVGKImage(named: "eye_view").uiImage
        btnDismissController.setTitle("", for: .normal)
        txtViewers.text = String(participents.count)
        
    }
    
    func UpdateParticipentsData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.participents = Cashe.streamParticipents
            self.tableView.reloadData()
            self.txtViewers.text = String(self.participents.count)
        }
    }
    
    @IBAction func didTapDismissVC(){
        
        self.dismiss(animated: true, completion: {
            self.delegeate?.didDismissController()
        })
    }
    
    private func setupTableView(){
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ParticipentsTableViewCell.getNib(), forCellReuseIdentifier: "\(ParticipentsTableViewCell.self)")
        
    }
    
    
    
    
    @objc private func didTapDone(){
        
        dismiss(animated: true)
    }

}


extension ParticipentViewController : UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ParticipentsTableViewCell.self)") as! ParticipentsTableViewCell
        cell.user =  participents[indexPath.row]
        cell.delegate = self
        cell.backgroundColor = .clear
        return cell
    }
    
    private func kickOut(_ id : String,cell : IndexPath){
        let path : DatabaseReference = FirebaseManager.shared.ref.child("streams/\("3")/participents/\(id)")
        FirebaseManager.shared.delete(path: path){[weak self] isDeleted in
            
//            if isDeleted{
//
//                if let result = self?.participents.firstIndex(where: { $0.id == id }){
//
//                    self?.sortParticipents.remove(at: result)
//                    self?.participents.remove(at: result)
//                    self?.tableView.deleteRows(at: [cell], with: .automatic)
//                }
//            }
        }
    }
}

extension ParticipentViewController : DelegateParticipentsVC{
    
    
    func didTapKickout(_ id: String) {
        print("kickout user id is",id)
        let parameters : [String:Any] = [
            "event_id":eventId,
            "content_viewer_id":id
        ]
        let apiService = APIManager(controller: self, headerType: .backend, parameters: parameters, endPoint: .kickoutUser, method: .post)
        apiService.postTest(model: GenerelResponse.self) {[weak self] response in
            self?.stopAnimating()
            switch response{
            case .success(let model):
                if model.success{
                    self?.updateFirebase(id)
                    self?.deleteBlockedUser(id)
                    self?.UpdateParticipentsData()
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    func didTapBlock(_ id: String, userName: String) {
        let parameters = [
            "content_viewer_id":id,
            "name": userName //Defaults.firstName+Defaults.lastName
        ]
        let apiService = APIManager(controller: self, headerType: .backend, parameters: parameters, endPoint: .blockUser, method: .post)
        startAnimating()
        apiService.postTest(model: GenerelResponse.self) {[weak self] response in
            self?.stopAnimating()
            switch response{
            case .success(let model):
                if model.success{
                    self?.updateFirebase(id)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self?.deleteBlockedUser(id)
                        self?.UpdateParticipentsData()
                    }
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    
    private func updateFirebase(_ userId : String){
        let id = String(eventId)
        let path : DatabaseReference = FirebaseManager.shared.ref.child("streams/\(id)/BlockedUsers/\(userId)")
        
        FirebaseManager.shared.Add(path: path, value: ["UserId":userId]) { response in
            
            switch response{
            case .success(let value):
                print("blocked user add reponse ststus is",value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    private func deleteBlockedUser(_ userId : String){
        let id = String(eventId)
        let path : DatabaseReference = FirebaseManager.shared.ref.child("streams/\(id)/participents/\(userId)")
        FirebaseManager.shared.delete(path: path){ response in
            switch response{
            case true:
                print("Delete blocked user success")
            case false:
                print("Delete blocked user fail")
            }
        }
    }
    
}



