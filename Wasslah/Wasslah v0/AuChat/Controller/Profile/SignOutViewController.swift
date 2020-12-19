//
//  SignOutViewController.swift
//  AuChat
//
//  Created by Lama on 27/04/1442 AH.
//

import UIKit
import FirebaseAuth

class SignOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signoutButton(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let vc = storyboard?.instantiateViewController(identifier: "showLogin") as! LogInViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc
                    , animated: true, completion: nil)
            print("Succssful sign out")
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        
    }
    

}
