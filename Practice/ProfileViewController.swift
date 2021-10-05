//
//  ProfileViewController.swift
//  Practice
//
//  Created by Sasha Styazhkin on 05.10.2021.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    



    @IBAction func backButtonAction(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
        
        let vc = storyboard?.instantiateViewController(identifier: "RegistrationViewController") as! RegistrationViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var menuContainerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var ref: DatabaseReference!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ref = Database.database().reference()
//        setView()
    }
    
    
    func setView() {
        let user = Auth.auth().currentUser
        ref = Database.database().reference()
        ref.child("users/\(user!.uid)").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.emailLabel.text = snapshot.childSnapshot(forPath: "email").value as? String ?? "Unknown"
            self.nameLabel.text = snapshot.childSnapshot(forPath: "name").value as? String ?? "Unknown"
        })
       
    }
    
}
