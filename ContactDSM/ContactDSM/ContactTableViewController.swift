//
//  ContactTableViewController.swift
//  ContactDSM
//
//  Created by 김수완 on 2020/08/04.
//  Copyright © 2020 김수완. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ContactTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var ref:DatabaseReference!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var findTextField: UITextField!
    
    var callList = [info]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        self.ref.child("UserCount").observeSingleEvent(of: .value) { snapshot1 in
            let data = snapshot1.value as? Int ?? 8
            
            for i in 0 ..< data{
                var name : String = ""
                var callNum : String = ""
                self.callList.append(info(name: name, callNum: callNum))
                    
                self.ref.child("info/user"+String(i)+"/name").observeSingleEvent(of: .value) { snapshot2 in
                    name = snapshot2.value as? String ?? "nothing"
                    self.callList[i].name = name
                }
                self.ref.child("info/user"+String(i)+"/callNum").observeSingleEvent(of: .value) { snapshot3 in
                    callNum = snapshot3.value as? String ?? "nothing"
                    self.callList[i].callNum = callNum
                    print(self.callList)
                    self.table.delegate = self
                    self.table.dataSource = self
                }
            }
        }
        
        
        findTextField.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let callNum = callList[indexPath.row]
        
        cell.textLabel?.text = callNum.name
        cell.detailTextLabel?.text = callNum.callNum
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 12)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let position = indexPath.row
        
        if let phoneCallUrl = URL(string: "tel://"+String(callList[position].callNum)) {
            let application:UIApplication = UIApplication.shared
                
            if (application.canOpenURL(phoneCallUrl)){
                application.open(phoneCallUrl, options: [:], completionHandler: nil)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func findBtn(_ sender: Any) {
        
        var findUsers = [info]()
        
        for i in 0..<callList.count{
            if callList[i].name == findTextField.text! {
                findUsers.append(info(name: callList[i].name, callNum: callList[i].callNum))
            }
        }
        
        guard let vc = storyboard?.instantiateViewController(identifier: "findName") as? findTableViewController else {
            return
        }
        
        vc.name = findTextField.text!
        vc.findUsers = findUsers
        present(vc, animated: true)
    }
    
    @IBAction func option(_ sender: Any) {
        let alert = UIAlertController(title: "로그아웃 하시겠습니까?", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .default, handler: nil)
        let okButton = UIAlertAction(title: "로그아웃", style: .default, handler: { action in
            UserDefaults.standard.removeObject(forKey: "id")
            UserDefaults.standard.removeObject(forKey: "pw")
            self.performSegue(withIdentifier: "logout", sender: self)
        })
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert,animated: true, completion: nil)
    }
    
}

struct info {
    var name: String
    var callNum: String
}
