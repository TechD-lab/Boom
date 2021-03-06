//
//  StartViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/13.
//

import UIKit
import Firebase

class StartViewController: UIViewController {

    @IBOutlet weak var input_text: UITextField!
    var VC: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    @IBAction func btn_clicked(_ sender: Any) {
        Auth.auth().createUser(withEmail: "tmtsale@naver.com", password: "dkssud110") { (user, err) in
            let uid = user?.user.uid
            Database.database().reference().child("Users").child(uid!).setValue(["name": self.input_text.text])
        }
    }
    
    @IBAction func login_btn(_ sender: Any) {
        Auth.auth().signIn(withEmail: "tmtsale@naver.com", password: "dkssud110") { (user, err) in
            let view = self.VC as! ViewController
            view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)
        }
    }
    
    func createUser() {
        let value: Dictionary<String, Any> = [
            "name": input_text.text!
        ]
        Database.database().reference().child("Users").childByAutoId().setValue(value)
    }

}
