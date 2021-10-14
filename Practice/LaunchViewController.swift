//
//  LaunchViewController.swift
//  Practice
//
//  Created by Sasha Styazhkin on 05.10.2021.
//

import UIKit
import Firebase

class LaunchViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            let vc = storyboard?.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
            _ = vc.view
            vc.modalPresentationStyle = .fullScreen
            vc.setView() {
//                print("presenting view")
                self.present(vc, animated: true, completion: nil)
            }
            
            
        } else {
            let vc = self.storyboard?.instantiateViewController(identifier: "SignViewController") as! SignViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }


}
