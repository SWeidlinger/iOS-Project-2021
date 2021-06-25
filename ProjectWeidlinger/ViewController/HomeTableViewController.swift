//
//  HomeTableViewController.swift
//  ProjectWeidlinger
//
//  Created by Sebastian Weidlinger on 22.06.21.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeTableViewController: UITableViewController {
    var data = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(UserDefaults().string(forKey: "firstName") ?? "User")'s Tasks"
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        fetchFirebaseData()
    }
    
    func fetchFirebaseData(){
        let priorityRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
        var priority3 = [String]()
        priorityRef.getDocument{(document, error) in
            if let document = document{
                let property = document.get("priority3") as! [String]
                priority3 = property
            }
        }
        
        var priority2 = [String]()
        priorityRef.getDocument{(document, error) in
            if let document = document{
                let property = document.get("priority2") as! [String]
                priority2 = property
            }
        }
        
        var priority1 = [String]()
        priorityRef.getDocument{(document, error) in
            if let document = document{
                let property = document.get("priority1") as! [String]
                priority1 = property
            }
            self.data = [priority3, priority2, priority1]
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTask", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1, green: 0.6, blue: 0.1, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.5
        
        let label = UILabel()
        label.text = "Priority \(3 - section)"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.frame = CGRect (x: 15, y: 0, width: 100, height: 40)
        view.addSubview(label)
        
        if (section == 0 && data[0].count > 2) {
            let button = UIButton(frame: CGRect(x: 240, y: 7.5, width: 100, height: 25))
            button.setTitle("Cheer me up", for: .normal)
            button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            //button.backgroundColor = UIColor.lightGray
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15)
            button.layer.cornerRadius = 10
            view.addSubview(button)
        }
        
        return view
    }
    
    @objc func buttonClicked(sender: UIButton){
        let cheerMeUpVC = self.storyboard?.instantiateViewController(identifier: "CheerMeUpVC") as? CheerMeUpViewController
        navigationController?.pushViewController(cheerMeUpVC!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let taskToRemove = data[indexPath.section][indexPath.row]
            let priorityRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
                self.data[indexPath.section].remove(at: indexPath.row)
                priorityRef.updateData(["priority\(3 - indexPath.section)": FieldValue.arrayRemove(["\(taskToRemove)"])])
                tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddTaskVC") as! AddTaskViewController
        vc.update = {
            DispatchQueue.main.async {
                self.fetchFirebaseData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
