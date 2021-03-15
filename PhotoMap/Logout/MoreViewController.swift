//
//  MoreViewController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 2/25/21.
//

import UIKit
import Firebase

// This view controller isn't described in the task

class MoreViewController: UIViewController {
    
   private let logoutButton = UIButton(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.setLogoutButton()

    }
    
   private func setLogoutButton()  {
        self.logoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoutButton)
        self.logoutButton.layer.borderWidth = 2
        self.logoutButton.setTitle("Logout", for: .normal)
        self.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)

        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            logoutButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70),
            logoutButton.widthAnchor.constraint(equalToConstant: 240),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func logout() {
        let firebaseAuth = Auth.auth()
    do {
        try firebaseAuth.signOut()
        self.navigationController?.popViewController(animated: true)
    } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
        self.showErrorAlert(message: "\(signOutError)")
        
    }
    }
    
    private func showErrorAlert(message: String)  {
        let alert = UIAlertController(title: "ERROR!!!", message: message, preferredStyle: .alert)
        
        let allertOkButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    
        alert.addAction(allertOkButton)
        self.present(alert, animated: true, completion: nil)
    }

}
