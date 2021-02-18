//
//  SignupViewController.swift
//  Boom
//
//  Created by 박진서 on 2021/02/18.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var againError: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var secondpassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alreadyLoggedIn()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        cancelEvent()
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        if password.text != secondpassword.text {
            let alert = UIAlertController(title: "알림", message: "비밀번호가 서로 다릅니다. 다시 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
            } ))
            self.present(alert, animated: true, completion: nil)
        } else {
            updateUI()
            signUpEvent()
        }
    }
    
    func alreadyLoggedIn() {
        if Auth.auth().currentUser != nil {
            self.name.placeholder = "이미 로그인 되었습니다"
            self.password.placeholder = "이미 로그인 되었습니다"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    func signUpEvent() {
       Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, err) in
           
           let errmessage = String(describing: err)
        let uid = user?.user.uid
        
           if user != nil {
            Database.database().reference().child("Users").child(uid!).setValue(["name": self.name.text])
               let alert = UIAlertController(title: "알림", message: "성공적으로 회원가입 되었습니다!\n 다시 로그인 해주세요", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                   self.cancelEvent()
               } ))
               self.present(alert, animated: true, completion: nil)
           } else {
               let alert = UIAlertController(title: "알림", message: "\(self.findErrorCode(error: errmessage))", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
               } ))
               self.present(alert, animated: true, completion: nil)
           }
       }
   }
    
    func findErrorCode(error: String) -> String{
        if error.contains("17026") {
            updateUI()
            passwordError.isHidden = false
            return ("비밀번호가 올바르지 않습니다.")
        } else if error.contains("17008"){
            updateUI()
            emailError.isHidden = false
            return ("이메일 형식이 올바르지 않습니다.")
        } else if error.contains("17034"){
            updateUI()
            emailError.isHidden = false
            return ("이메일을 입력해주세요.")
        } else {
            return ""
        }
    }
    
    func updateUI() {
        emailError.isHidden = true
        passwordError.isHidden = true
        againError.isHidden = true
    }

    func cancelEvent() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
