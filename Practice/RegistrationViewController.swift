//
//  RegistrationViewController.swift
//  Practice
//
//  Created by Sasha Styazhkin on 03.10.2021.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error)
                self.errorLabel.text = error?.localizedDescription.description
                return
            }
            
            // successfully authentificated
            
            guard let uid = authResult?.user.uid else {
                return
            }
            
            let ref = Database.database(url: "https://practice-4d531-default-rtdb.europe-west1.firebasedatabase.app").reference()
            let usersRef = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersRef.updateChildValues(values) { err, ref in
                if err != nil {
                    print(err)
                    return
                }
                self.errorLabel.text = ""
                print("Saved user successfully")
            }
            let vc = self.storyboard?.instantiateViewController(identifier: "SignViewController") as! SignViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
          }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        // Do any additional setup after loading the view.
    }
    

}
