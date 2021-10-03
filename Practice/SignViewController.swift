//
//  SignViewController.swift
//  Practice
//
//  Created by Sasha Styazhkin on 03.10.2021.
//

import UIKit
import Firebase

class SignViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signButton: UIButton!
    
    @IBAction func signButtonAction(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if authResult != nil {
                let vc = self?.storyboard?.instantiateViewController(identifier: "TabBarConrollerID") as! UITabBarController
                vc.modalPresentationStyle = .fullScreen
                self!.present(vc, animated: true)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
