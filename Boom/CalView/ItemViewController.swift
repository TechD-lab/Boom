//
//  ItemViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/14.
//

import UIKit
import Firebase

class ItemViewController: UIViewController {

    @IBOutlet weak var button_Cancel: UIButton!
    @IBOutlet weak var button_Done: UIButton!
    @IBOutlet weak var money_text: UITextField!
    @IBOutlet weak var name_text: UITextField!
    
    @IBOutlet weak var button_people: UIButton!
    @IBOutlet weak var button_charged: UIButton!
    
    @IBOutlet weak var mode_changer: UISwitch!
    @IBOutlet weak var easy_count_label: UILabel!
    @IBOutlet weak var easy_stepper: UIStepper!
    @IBOutlet weak var arrow_one: UIImageView!
    @IBOutlet weak var arrow_two: UIImageView!
    
    var updateTableView: (() -> Void)?
        
    var calUid: String?
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode_changer.isOn = false
        easy_stepper.isHidden = true
        easy_count_label.isHidden = true
        
        ref.child("Users").child(uid!).child("CalItems").observeSingleEvent(of: DataEventType.value) { (DataSnapshot) in
            for item in DataSnapshot.children.allObjects as! [DataSnapshot] {
                let values = item.value as! [String: Any]
                if values["uid"] as? String == self.calUid {
                    self.name_text.placeholder = values["name"] as? String
                    self.money_text.placeholder = values["totalCost"] as? String ?? "0"
                }
                
            }
        }
        
        
        
        
    }
    
    @IBAction func cancel_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switch_action(_ sender: UISwitch) {
        
        if sender.isOn == true {
            easy_stepper.isHidden = false
            easy_count_label.isHidden = false
            arrow_one.isHidden = true
            arrow_two.isHidden = true
            button_people.isEnabled = false
            button_charged.isEnabled = false
        } else {
            easy_stepper.isHidden = true
            easy_count_label.isHidden = true
            arrow_two.isHidden = false
            arrow_one.isHidden = false
            button_people.isEnabled = true
            button_charged.isEnabled = true
        }
    }
    @IBAction func btn_people_clicked(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(identifier: "PeopleViewController") as! PeopleViewController
        VC.modalPresentationStyle = .fullScreen
        VC.calUid = calUid
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func done_clicked(_ sender: Any) {
                
        if Int(money_text.text!) == nil  || Int(money_text.text!)! < 0{
            let alert = UIAlertController(title: "오류 발생", message: "총 금액에는 숫자만 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if name_text.text == "" {
            ref.child("Users").child(uid!).child("CalItems").child(calUid!).child("name").setValue("장소 이름")
            ref.child("Users").child(uid!).child("CalItems").child(calUid!).child("totalCost").setValue(Int(money_text.text!))
            updateTableView?()
            self.dismiss(animated: true, completion: nil)
        } else {
            ref.child("Users").child(uid!).child("CalItems").child(calUid!).child("totalCost").setValue(Int(money_text.text!))
            ref.child("Users").child(uid!).child("CalItems").child(calUid!).child("name").setValue(name_text.text)
            updateTableView?()
            self.dismiss(animated: true, completion: nil)
        }
                
    //    ref.child("Users").child(uid!).child("CalItems").child(calUid!).child("totalCost").setValue(money_text.text as! Int)
    }
    
}
