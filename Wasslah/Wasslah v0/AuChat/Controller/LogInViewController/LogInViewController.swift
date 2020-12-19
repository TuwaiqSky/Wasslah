//
//  ViewController.swift
//  AuChat
//
//  Created by Hanan on 04/12/2020.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var logButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUser()
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
        logButton.layer.cornerRadius = 20
        errorLabel.alpha = 0
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        // Validate the fields
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.shakePassword()
                self.errorLabel.alpha = 1
                self.errorLabel.isHidden = false
                self.errorLabel.text = "User name or password is wrong"
            }
            
            else {
                
            let tabBar = self.storyboard?.instantiateViewController(identifier: "tabBar")
                
                self.view.window?.rootViewController = tabBar
                self.view.window?.makeKeyAndVisible()
            }
            if self.passwordTextField.text == "" {
                self.shakePassword()
                self.errorLabel.text = "Fill all feild"
                self.errorLabel.isHidden = false
            }
            
        }
    }
    
    
    func authUser() {
        DispatchQueue.main.async { [weak self] in
            if Auth.auth().currentUser?.uid != nil {
                let audioListVC = self?.storyboard?.instantiateViewController(identifier: "tabBar")
                self?.view.window?.rootViewController = audioListVC
                self?.view.window?.makeKeyAndVisible()
            }
        }
        
        
        
    }
    
    
    
    
    func isValidEmail(_ email: String) -> Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailPred.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
      let minPasswordLength = 6
      return password.count >= minPasswordLength
    }
    
    
    func shakePassword () {
        let animation = CABasicAnimation(keyPath: "position")
        let myColor = UIColor.red
        passwordTextField.layer.borderColor = myColor.cgColor
        passwordTextField.layer.borderWidth = 2
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x - 4, y: passwordTextField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x + 4, y: passwordTextField.center.y))

        passwordTextField.layer.add(animation, forKey: "position")
        self.shakeinfoLabel()
    }
    
    func shakeinfoLabel () {
        let animation = CABasicAnimation(keyPath: "position")

        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: errorLabel.center.x - 4, y: errorLabel.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: errorLabel.center.x + 4, y: errorLabel.center.y))

        errorLabel.layer.add(animation, forKey: "position")


    }
    
    // Should return function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


