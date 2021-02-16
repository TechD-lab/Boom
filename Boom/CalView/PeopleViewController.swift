//
//  PeopleViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/16.
//

import UIKit
import Firebase

class PeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var checkedPeopleList: [people] = []
    var uncheckedPeopleList: [people] = []
    
    let ref = Database.database().reference()
    let uid: String? = Auth.auth().currentUser?.uid
    var calUid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.checkedPeopleList.removeAll()
        self.uncheckedPeopleList.removeAll()
        self.tableView.reloadData()
        
        //화면 띄울 때 Firebase 에서 데이터 가져와서 집어넣기
        
        ref.child("Users").child(uid!).child("PeopleList").observeSingleEvent(of: DataEventType.value, with: { (DataSnapshot) in
            for item in DataSnapshot.children.allObjects as! [DataSnapshot] {
            
                let values = item.value as! [String: Any]
                var newPeople = people()
                newPeople.name = values["name"] as? String
                newPeople.uid = values["uid"] as? String
                
                if values[self.calUid!] == nil {
                    self.ref.child("Users").child(self.uid!).child("PeopleList").child(values["uid"] as! String).child(self.calUid!).setValue(false)
                    self.uncheckedPeopleList.append(newPeople)
                } else {
                    
                    if values[self.calUid!] as! Int == 0 {
                        self.uncheckedPeopleList.append(newPeople)
                    } else {
                        self.checkedPeopleList.append(newPeople)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func plus_clicked(_ sender: Any) {
        
        
        //Users - uid - people  안에 사람 목록 추가 Firebase Data
        let value: Dictionary<String, Any> = [
            "name": "이름",
            "uid": ref.child("Users").child(uid!).child("PeopleList").childByAutoId().key!,
            calUid!: false
        ]
        let peopleUid = value["uid"] as! String
        
        
        //uncheckedPeopleList 에 추가 ( 기본 )
        
        var newPeople = people()
        newPeople.name = value["name"] as? String
        newPeople.uid = value["uid"] as? String
        uncheckedPeopleList.append(newPeople)
        
        ref.child("Users").child(uid!).child("PeopleList").child(peopleUid).setValue(value)
               
        self.tableView.reloadData()
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return checkedPeopleList.count
        } else {
            return uncheckedPeopleList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell") as! PeopleCell
        cell.change_name.isHidden = true
        cell.btn_change.isHidden = true
        
        if indexPath.section == 0 {
            cell.cellChecked()
            cell.peopleUid = checkedPeopleList[indexPath.row].uid
            cell.cell_name.text = checkedPeopleList[indexPath.row].name
        } else {
            cell.cellUnChecked()
            cell.peopleUid = uncheckedPeopleList[indexPath.row].uid
            cell.cell_name.text = uncheckedPeopleList[indexPath.row].name
        }
        cell.index = indexPath.row

        cell.checkBtnTapHandler = {
            if cell.isChecked == true {
                cell.cellUnChecked()
                //people 구조체 가져오기
                let people = self.checkedPeopleList[cell.index!]
                self.checkedPeopleList.remove(at: cell.index!)
                cell.index = self.uncheckedPeopleList.count
                self.uncheckedPeopleList.append(people)
                
                self.ref.child("Users").child(self.uid!).child("PeopleList").child(cell.peopleUid!).child(self.calUid!).setValue(false)
                
            } else {
                cell.cellChecked()
                
                let people = self.uncheckedPeopleList[cell.index!]
                self.uncheckedPeopleList.remove(at: cell.index!)
                cell.index = self.checkedPeopleList.count
                self.checkedPeopleList.append(people)
                
                self.ref.child("Users").child(self.uid!).child("PeopleList").child(cell.peopleUid!).child(self.calUid!).setValue(true)
            }
            
            self.tableView.reloadData()
            
        }
        
        cell.optionBtnTapHandler = {
            cell.optionTapped()
        }
        
        cell.changeBtnTapHandler = {
            if indexPath.section == 0 {
                self.checkedPeopleList[indexPath.row].name = cell.change_name.text
            } else {
                self.uncheckedPeopleList[indexPath.row].name = cell.change_name.text
            }
            
            self.ref.child("Users").child(self.uid!).child("PeopleList").child(cell.peopleUid!).child("name").setValue(cell.change_name.text)
            self.tableView.reloadData()
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }

    @IBAction func done_clicked(_ sender: Any) {
        
        var count: Int = 0
        
        ref.child("Users").child(uid!).child("PeopleList").observeSingleEvent(of: DataEventType.value, with: { (DataSnapshot) in
            for item in DataSnapshot.children.allObjects as! [DataSnapshot] {
                let values = item.value as! [String: Any]
                if values[self.calUid!] as! Int == 1 {
                    count += 1
                }
            }
            self.ref.child("Users").child(self.uid!).child("CalItems").child(self.calUid!).child("totalCount").setValue(count)
        })

        
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

class PeopleCell: UITableViewCell {
    @IBOutlet weak var cell_name: UILabel!
    @IBOutlet weak var cell_check_btn: UIButton!
    @IBOutlet weak var uncheck_image: UIImageView!
    @IBOutlet weak var check_image: UIImageView!
    @IBOutlet weak var btn_option: UIButton!
    @IBOutlet weak var change_name: UITextField!
    @IBOutlet weak var btn_change: UIButton!
    
    var checkBtnTapHandler: (() -> Void)?
    var optionBtnTapHandler: (() -> Void)?
    var changeBtnTapHandler: (() -> Void)?
    
    var peopleUid: String?
    var index: Int?
    
    var isChecked: Bool = false
    
    func cellChecked() {
        check_image.isHidden = false
        uncheck_image.isHidden = true
        self.isChecked = true
    }
    
    func cellUnChecked() {
        check_image.isHidden = true
        uncheck_image.isHidden = false
        self.isChecked = false
    }
    
    func optionTapped() {
        self.cell_name.isHidden = true
        self.cell_check_btn.isEnabled = false
        self.change_name.isHidden = false
        self.btn_change.isHidden = false
        self.btn_option.isHidden = true
    }
    
    func changeTapped() {
        self.cell_name.isHidden = false
        self.cell_check_btn.isEnabled = true
        self.change_name.isHidden = true
        self.btn_change.isHidden = true
        self.btn_option.isHidden = false
    }
    
    @IBAction func check_btn_clicked(_ sender: Any) {
        checkBtnTapHandler?()
    }
    
    @IBAction func option_clicked(_ sender: Any) {
        optionBtnTapHandler?()
    }
    
    @IBAction func change_btn_clicked(_ sender: Any) {
        changeTapped()
        changeBtnTapHandler?()
    }
    
    
}
