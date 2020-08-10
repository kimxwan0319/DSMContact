//
//  ViewController.swift
//  ContactDSM
//
//  Created by 김수완 on 2020/08/03.
//  Copyright © 2020 김수완. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = UserDefaults.standard.string(forKey: "id"){
            if let pw = UserDefaults.standard.string(forKey: "pw"){
                Auth.auth().signIn(withEmail: id, password: pw) { (user, error) in
                    if user != nil {
                        self.performSegue(withIdentifier: "login", sender: self)
                    }
                }
            }
        }
            
        emailTextField.delegate = self
        passwordTextField.delegate = self

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

    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                UserDefaults.standard.set(self.emailTextField.text, forKey: "id")
                UserDefaults.standard.set(self.passwordTextField.text, forKey: "pw")
                self.performSegue(withIdentifier: "login", sender: self)
            }
            else {
                let alert = UIAlertController(title: "아이디나 비밀번호를 확인해 주세요.", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert,animated: true, completion: nil)
                
            }
        }
    }
    
}
