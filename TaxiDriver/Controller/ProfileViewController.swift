//
//  ProfileViewController.swift
//  TaxiDriver
//
//  Created by Ye Lynn Htet on 29/12/2021.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var profileCoverView: UIView!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        decorateUI()
        
        usernameLabel.text = userDefaults.string(forKey: "username")
        emailLabel.text = userDefaults.string(forKey: "email")
        setImage(with: userDefaults.string(forKey: "profileURL")!)
        
    }
    
    func decorateUI() {
        profileCoverView.layer.cornerRadius = 16
        profileContainerView.layer.cornerRadius = 94
        profileImage.layer.cornerRadius = 94
        logoutButton.layer.cornerRadius = 28
    }
    
    func setImage(with urlString: String) {
        let url = URL(string: urlString)!
        let placeholderImage = UIImage(named: "profile_sample")

        profileImage.af.setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.2))
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
