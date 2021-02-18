//
//  ChargeViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/17.
//

import UIKit
import Firebase

class ChargeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var peopleList: [people] = []
    var calUid: String?
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        //Firebase 에서 가져오기
        ref.child("Users").child(uid!).child("PeopleList").observeSingleEvent(of: DataEventType.value) { (DataSnapshot) in
            for items in DataSnapshot.children.allObjects as! [DataSnapshot] {
                let values = items.value as! [String: Any]
                if values[self.calUid!] == nil {
                    
                    let alert = UIAlertController(title: "오류 발생", message: "사람이 추가되지 않았습니다. '참여한 사람들' 에서 사람을 추가해주세요. ", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                } else if values[self.calUid!] as! Int == 1 {
                    var newpeople = people()
                    newpeople.name = values["name"] as? String
                    newpeople.uid = values["uid"] as? String
                    self.peopleList.append(newpeople)
                }
                
                

            }
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChargeCell") as! ChargeCell
        
        let who = peopleList[indexPath.row]
        cell.label_name.text = who.name
        cell.mainBtnTapHandler = {
            self.ref.child("Users").child(self.uid!).child("CalItems").child(self.calUid!).child("whoCharged").setValue(who.uid!)
            
            
            cell.updateCell()
            self.dismiss(animated: true, completion: nil)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    @IBAction func cancel_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

class ChargeCell : UITableViewCell {
    @IBOutlet weak var label_name: UILabel!
    var isChecked = false
    var mainBtnTapHandler: (() -> Void)?
    
    func updateCell() {
        if isChecked == false {
            self.backgroundColor = UIColor.green
            isChecked = true
        } else {
            self.backgroundColor = UIColor.white
            isChecked = false
        }
    }
    @IBAction func button_clicked(_ sender: Any) {
        
        mainBtnTapHandler?()
    }
    
}
