//
//  AddTaskViewController.swift
//  ProjectWeidlinger
//
//  Created by Sebastian Weidlinger on 25.06.21.
//

import UIKit

class AddTaskViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var priorityPicker: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerFont = UIFont.systemFont(ofSize: 20)
        priorityPicker.setTitleTextAttributes([NSAttributedString.Key.font : pickerFont], for: .normal)
        textField.becomeFirstResponder()
        errorLabel.isHidden = true
    }
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        if (textField.hasText){
            errorLabel.isHidden = true
            navigationController?.popViewController(animated: true)
        }
        else{
            errorLabel.isHidden = false
        }
    }
}
