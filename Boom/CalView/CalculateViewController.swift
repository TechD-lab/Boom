//
//  CalculateViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/09.
//

import UIKit
import Firebase

class CalculateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var calItems: [CalculateItem] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCost: UILabel!
    
    
    let ref = Database.database().reference()
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        //calItems 파이어베이스 데이터베이스에서 불러와 calItems에 집어넣기
        uid = Auth.auth().currentUser?.uid
        ref.child("Users").child(uid!).child("CalItems").observeSingleEvent(of: DataEventType.value, with: { (DataSnapshot) in
            for item in DataSnapshot.children.allObjects as! [DataSnapshot] {
                let values = DataSnapshot.value as! [String: Any]
                let final = values[item.key]! as! [String: Any]
                let calItem = CalculateItem()
                
                calItem.name = final["name"] as? String
                calItem.peoples = final["peoples"] as? [people]
                calItem.totalCost = final["totalCost"] as? Int
                calItem.uid = item.key
                self.calItems.append(calItem)
            }
            self.tableView.reloadData()
        })
        
        updateTotalCost()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalculateViewCell") as! CalculateViewCell
        cell.button_cell.layer.cornerRadius = 8

        //calItems 에서 정보 받아오기
        cell.cell_main.text = calItems[indexPath.row].name
        cell.cell_money.text = "\(String(describing: calItems[indexPath.row].totalCost!))"
        
        let cellUid = calItems[indexPath.row].uid
        //cell 흰 버튼 클릭 이벤트
        cell.mainButtonTapHandler = {
            let VC = self.storyboard?.instantiateViewController(identifier: "ItemViewController") as! ItemViewController
            VC.modalPresentationStyle = .fullScreen
            VC.calUid = cellUid
            VC.calVC = self
            VC.updateTableView = {
                self.calItems[indexPath.row].name = VC.name_text.text
                self.calItems[indexPath.row].totalCost = Int(VC.money_text.text!)
                self.tableView.reloadData()
            }            
            self.present(VC, animated: true, completion: nil)
        }
        
        
        
        //cell 의 deleteButtonTapHandler
        cell.deleteButtonTapHandler = {
            // Firebase DB 에서 지우기
            let itemUid = self.calItems[indexPath.row].uid
            self.ref.child("Users").child(self.uid!)
                .child("CalItems").child(itemUid!).removeValue()
            
            //peopleList 에서 지우기
            self.ref.child("Users").child(self.uid!).child("PeopleList").observeSingleEvent(of: DataEventType.value) { (DataSnapshot) in
                for people in DataSnapshot.children.allObjects as! [DataSnapshot] {
                    let values = people.value as! [String: Any]
                    if values[itemUid!] != nil {
                        self.ref.child("Users").child(self.uid!).child("PeopleList").child(values["uid"] as! String).child(itemUid!).removeValue()
                    }
                }
            }
            
            
            //calItems 에서 지우기
            self.calItems.remove(at: indexPath.row)
            self.updateTotalCost()
            self.tableView.reloadData()
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func updateTotalCost() {
        var tC = 0
        ref.child("Users").child(self.uid!).child("CalItems").observe(DataEventType.value) { (DataSnapshot) in
            tC = 0
            for item in DataSnapshot.children.allObjects as! [DataSnapshot] {
                let values = item.value as! [String: Any]
                
                tC += values["totalCost"] as! Int
            }
            self.totalCost.text = "\(tC)"
        }
    }
    @IBAction func final_btn_clicked(_ sender: Any) {
        let view = self.storyboard?.instantiateViewController(identifier: "FinalViewController") as! FinalViewController
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
}

class CalculateViewCell: UITableViewCell {
    @IBOutlet weak var button_cell: UIButton!
    @IBOutlet weak var cell_main: UILabel!
    @IBOutlet weak var cell_money: UILabel!
    @IBOutlet weak var delete_btn: UIButton!
    var deleteButtonTapHandler: (() -> Void)?
    var mainButtonTapHandler: (() -> Void)?
    
    @IBAction func delete_clicked(_ sender: Any) {
        deleteButtonTapHandler?()
    }
    @IBAction func mainBtn_clicked(_ sender: Any) {
        mainButtonTapHandler?()
    }

    
}
