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
        title = "\(UserDefaults().string(forKey: "firstName") ?? "User")'s S****"
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
        var color = UIColor()
        let current = UserDefaults().integer(forKey: "sectionColor")
        switch current{
        case 1:
            color = UIColor.systemBlue
        case 2:
            color = UIColor.systemGreen
        case 3:
            color = UIColor.systemYellow
        case 4:
            color = UIColor.systemOrange
        case 5:
            color = UIColor.systemPurple
        default:
            color = UIColor.systemGray
        }
        
        view.backgroundColor = color
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        
        let label = UILabel()
        label.text = "Priority \(3 - section)"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.frame = CGRect (x: 15, y: 0, width: 100, height: 40)
        view.addSubview(label)
        
        if (section == 0 && data[0].count > 2) {
            let button = showCheerMeUpButton()
            view.addSubview(button)
        }
        else if (section == 1 && data[1].count > 4) {
            let button = showCheerMeUpButton()
            view.addSubview(button)
        }
        else if (section == 2 && data[2].count > 6) {
            let button = showCheerMeUpButton()
            view.addSubview(button)
        }
        
        return view
    }
    
    func showCheerMeUpButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 240, y: 7.5, width: 100, height: 25))
        button.setTitle("Sh**** day?", for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        return button
    }
    
    @objc func buttonClicked(sender: UIButton){
        let cheerMeUpVC = self.storyboard?.instantiateViewController(identifier: "CheerMeUpVC") as? CheerMeUpViewController
        navigationController?.pushViewController(cheerMeUpVC!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let taskToRemove = data[indexPath.section][indexPath.row]
            let priorityRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
            self.data[indexPath.section].remove(at: indexPath.row)
            priorityRef.updateData(["priority\(3 - indexPath.section)": FieldValue.arrayRemove(["\(taskToRemove)"])])
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
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
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SettingsVC") as! SettingsViewController
        vc.update = {
            DispatchQueue.main.async {
                self.fetchFirebaseData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
