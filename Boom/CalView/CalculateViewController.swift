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
        
        //cell 흰 버튼 클릭 이벤트
        cell.mainButtonTapHandler = {
            let VC = self.storyboard?.instantiateViewController(identifier: "ItemViewController") as! ItemViewController
            VC.modalPresentationStyle = .fullScreen
            
            self.present(VC, animated: true, completion: nil)
        }
        
        
        
        //cell 의 deleteButtonTapHandler
        cell.deleteButtonTapHandler = {
            // Firebase DB 에서 지우기
            let itemUid = self.calItems[indexPath.row].uid
            self.ref.child("Users").child(self.uid!)
                .child("CalItems").child(itemUid!).removeValue()
            
            //calItems 에서 지우기
            self.calItems.remove(at: indexPath.row)
            self.tableView.reloadData()
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
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
