//
//  findTableViewController.swift
//  ContactDSM
//
//  Created by 김수완 on 2020/08/10.
//  Copyright © 2020 김수완. All rights reserved.
//

import UIKit

class findTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var name : String = ""
    public var findUsers : [info] = []
    
    @IBOutlet weak var findingName: UILabel!
    @IBOutlet weak var findTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findingName.text = name
        
        self.findTableView.delegate = self
        self.findTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return findUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let callNum = findUsers[indexPath.row]
        
        cell.textLabel?.text = callNum.name
        cell.detailTextLabel?.text = callNum.callNum
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 12)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let position = indexPath.row
        
        if let phoneCallUrl = URL(string: "tel://"+String(findUsers[position].callNum)) {
            let application:UIApplication = UIApplication.shared
                
            if (application.canOpenURL(phoneCallUrl)){
                application.open(phoneCallUrl, options: [:], completionHandler: nil)
            }
        }
    }

}
