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
    var index: Int = 0
    
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
                print(self.calItems.count)
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
        cell.cell_main.text = calItems[index].name
        cell.cell_money.text = "\(String(describing: calItems[index].totalCost!))"
        index += 1
        
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
    
}
