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
    let user = Auth.auth().currentUser
    typealias FinishedSetting = () -> ()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        profileImage.addGestureRecognizer(tapGR)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderWidth = 4
        profileImage.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
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
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let profileImageRef = storageRef.child("images/\(user!.uid)/profileImage.jpg")
        
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
        
        group.enter()
        profileImageRef.downloadURL { url, error in
          if let error = error {
            self.profileImage.image = UIImage(named: "avatar")
          } else {
            let data = try? Data(contentsOf: url!)
            self.profileImage.image = UIImage(data: data!)
          }
        }
        group.leave()
        
        group.notify(queue: .main, execute: {
//            print("Done with data")
            completed()
        })
    }
    
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profileImage.image = image
            saveImageToStorage()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    
    
    func saveImageToStorage() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let profileImageRef = storageRef.child("images/\(user!.uid)/profileImage.jpg")
        
        let uploadTask = profileImageRef.putData((profileImage.image?.pngData())!, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          profileImageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
        
    }
    
    func loadImageFromUrlString(urlString: String?) -> UIImage? {
        let url = URL(string: urlString!)
        let data = try? Data(contentsOf: url!)
        return UIImage(data: data!)
    }
    
}
