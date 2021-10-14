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
        
        let vc = storyboard?.instantiateViewController(identifier: "SignViewController") as! SignViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var menuContainerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    
    var ref: DatabaseReference!
    typealias FinishedSetting = () -> ()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        profileImage.addGestureRecognizer(tapGR)
    }
    
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
        }
    }
    
    func setView(completed: @escaping FinishedSetting) {
        let user = Auth.auth().currentUser
        let group = DispatchGroup()
        
        ref = Database.database().reference()
        group.enter()
        ref.child("users/\(user!.uid)").getData(completion: { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.emailLabel.text = snapshot.childSnapshot(forPath: "email").value as? String ?? "Unknown"
            self.nameLabel.text = (snapshot.childSnapshot(forPath: "name").value as? String ?? "Unknown") + " 👋"
        
            group.leave()
        })
        
        group.notify(queue: .main, execute: {
//            print("Done with data")
            completed()
        })
    }
    
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}
