//
//  AddTaskViewController.swift
//  ProjectWeidlinger
//
//  Created by Sebastian Weidlinger on 25.06.21.
//

import UIKit
import Firebase
import FirebaseAuth

class AddTaskViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var priorityPicker: UISegmentedControl!
    var update: (() -> Void)?
    
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
            let dbRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
            dbRef.updateData(["priority\(priorityPicker.selectedSegmentIndex + 1)": FieldValue.arrayUnion(["\(textField.text ?? "")"])])
            update?()
            navigationController?.popViewController(animated: true)
        }
        else{
            errorLabel.isHidden = false
        }
    }
}
