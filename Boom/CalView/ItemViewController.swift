//
//  ItemViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/14.
//

import UIKit

class ItemViewController: UIViewController {

    @IBOutlet weak var button_Cancel: UIButton!
    @IBOutlet weak var button_Done: UIButton!
    @IBOutlet weak var money_text: UITextField!
    
    @IBOutlet weak var button_people: UIButton!
    @IBOutlet weak var button_charged: UIButton!
    
    @IBOutlet weak var mode_changer: UISwitch!
    @IBOutlet weak var easy_count_label: UILabel!
    @IBOutlet weak var easy_stepper: UIStepper!
    @IBOutlet weak var arrow_one: UIImageView!
    @IBOutlet weak var arrow_two: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode_changer.isOn = false
        easy_stepper.isHidden = true
        easy_count_label.isHidden = true
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
        } else {
            easy_stepper.isHidden = true
            easy_count_label.isHidden = true
            arrow_two.isHidden = false
            arrow_one.isHidden = false
        }
    }
    

}