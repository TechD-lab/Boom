//
//  LoginViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/18.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var VC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    
    func presentSignup() {
        let view = self.storyboard?.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
        view.updateUI()
    }
    
    @IBAction func tapBG(_ sender: Any) {
        email.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    func showWrongPassword() {
        let alert = UIAlertController(title: "알림", message: "로그인에 실패했습니다. 이메일 또는 비밀번호를 확인해주세요", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
            
        } ))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func signup(_ sender: Any) {
        presentSignup()
    }
    
    @IBAction func signin(_ sender: Any) {
        loginEvent()
    }
    
    func loginEvent() {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if user != nil {
                let view = self.VC as! ViewController
                view.modalPresentationStyle = .fullScreen
                self.present(view, animated: true, completion: nil)
            } else {
                self.showWrongPassword()
            }
        }
    }
}
