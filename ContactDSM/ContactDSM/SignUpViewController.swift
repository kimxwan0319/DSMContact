//
//  SignUpViewController.swift
//  ContactDSM
//
//  Created by 김수완 on 2020/08/03.
//  Copyright © 2020 김수완. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var ref : DatabaseReference!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordChek: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var callNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        password.delegate = self
        passwordChek.delegate = self
        nameTextField.delegate = self
        callNumber.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func notice(_ phrases : String) {
        let alert = UIAlertController(title: phrases, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true, completion: nil)
    }
    
    @IBAction func NextBtn(_ sender: UIButton) {
        if (emailTextField.text != "" &&
            password.text != "" &&
            nameTextField.text != "" &&
            callNumber.text != "" &&
            password.text! == passwordChek.text! ) {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: password.text!) { (user, error) in
                if user != nil{
                    print("user Created")
                    
                    self.ref = Database.database().reference()
                    self.ref.child("UserCount").observeSingleEvent(of: .value) { snapshot in
                        let count = snapshot.value as? Int ?? 8
                        let nameItem = self.ref.child("info/user"+String(count)+"/name")
                        let callNumItem = self.ref.child("info/user"+String(count)+"/callNum")
                        let c = self.ref.child("UserCount")
                        nameItem.setValue(self.nameTextField.text)
                        callNumItem.setValue(self.callNumber.text)
                        c.setValue(count+1)
                    }

                    
                    self.performSegue(withIdentifier: "goSingin", sender: self)
                }
                else {
                    print("error")
                }
            }
        }
        else {
            if emailTextField.text == "" {
                notice("이메일을 입력해 주세요.")
            }
            else if nameTextField.text == "" {
                notice("이름을 입력해 주세요.")
            }
            else if callNumber.text == "" {
                notice("전화번호를 입력해 주세요.")
            }
            else if (password.text! != passwordChek.text!) || password.text == "" {
                notice("비밀번호를 확인해 주세요.")
            }
        }
    }
    
}
