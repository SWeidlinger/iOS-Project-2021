//
//  SettingsViewController.swift
//  ProjectWeidlinger
//
//  Created by Sebastian Weidlinger on 26.06.21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var changeSectionColorButton: UIButton!
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signOutButton.layer.borderColor = UIColor.black.cgColor
        signOutButton.layer.borderWidth = 2
        signOutButton.layer.cornerRadius = 10
        changePasswordButton.layer.borderColor = UIColor.black.cgColor
        changePasswordButton.layer.borderWidth = 2
        changePasswordButton.layer.cornerRadius = 10
        changeSectionColorButton.layer.borderColor = UIColor.black.cgColor
        changeSectionColorButton.layer.borderWidth = 2
        changeSectionColorButton.layer.cornerRadius = 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        update?()
    }
}
