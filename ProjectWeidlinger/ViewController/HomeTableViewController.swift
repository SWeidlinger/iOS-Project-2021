//
//  HomeTableViewController.swift
//  ProjectWeidlinger
//
//  Created by Sebastian Weidlinger on 22.06.21.
//

import UIKit

class HomeTableViewController: UITableViewController {
    let data = [["Very important stuff", "even more Important Stuff", "soo much important stuff"], ["not so important Stuff", "still kinda important tho"], ["dont even bother doing this stuff here"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(UserDefaults().string(forKey: "firstName") ?? "User")'s Tasks"
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
            
        }
        else if editingStyle == .insert{
            
        }
    }
}
