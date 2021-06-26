//
//  LoginViewController.swift
//  ProjectWeidlinger
//
//  Created by Sebastian Weidlinger on 22.06.21.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.borderWidth = 2
        loginButton.layer.cornerRadius = 10
        signUpButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
        setUpElements()
        activityIndicator.color = UIColor.black
        emailTextField.becomeFirstResponder()
    }
    
    func setUpElements(){
        
        //Hide error Label
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String?{
        
        //check that all fields are filled returns error message if not filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields"
        }
        return nil
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        //Validate Text Fields
        
        //validate fields
        let error = validateFields()
        
        if error != nil{
            showError(error!)
        }
        else{
            self.errorLabel.alpha = 0
            activityIndicator.startAnimating()
            //create cleaned text of textfields
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Signing in the User
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                
                if error != nil{
                    //couldnt sign in
                    self.errorLabel.text = "Email or Password incorrect"
                    self.errorLabel.alpha = 1
                    self.activityIndicator.stopAnimating()
                }
                else{
                    self.errorLabel.alpha = 0
                    let docRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
                    docRef.getDocument{(document, error) in
                        if let document = document{
                            let property = document.get("firstName")
                            UserDefaults.standard.set(property as! String, forKey: "firstName")
                        }
                        let homeNavigationVC = self.storyboard?.instantiateViewController(identifier: "homeNavigationVC") as? HomeNavigationController
                        
                        self.activityIndicator.stopAnimating()
                        
                        self.view.window?.rootViewController = homeNavigationVC
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            }
        }
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}

