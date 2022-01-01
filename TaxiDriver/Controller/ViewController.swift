//
//  ViewController.swift
//  TaxiDriver
//
//  Created by Ye Lynn Htet on 29/12/2021.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        signInButton.layer.cornerRadius = 28
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        checkSignIn()
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func checkSignIn(){
        if GIDSignIn.sharedInstance().currentUser != nil {
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "GoToHome", sender: self)
            }
        }
    }
    

}

extension ViewController: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            userDefaults.setValue(user.profile.name, forKey: "username")
            userDefaults.setValue(user.profile.email, forKey: "email")
            if user.profile.hasImage {
                let profileurl = user.profile.imageURL(withDimension: .min).absoluteString
                userDefaults.setValue(profileurl, forKey: "profileURL")
            }
            self.performSegue(withIdentifier: "GoToHome", sender: self)
        }
    }
}

