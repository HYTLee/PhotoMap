//
//  LoginViewController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/15/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    private let emailTextField = UITextField(frame: CGRect.zero)
    private let passwordTextField = UITextField(frame: CGRect.zero)
    private let loginButton = UIButton(frame: CGRect.zero)
    private let registrationButton = UIButton(frame: CGRect.zero)
    private let skipLoginButton = UIButton(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLoginTextField()
        self.setPasswordTextField()
        self.setLoginButton()
        self.setRegistrationButton()
        self.setSkipLoginButton()
    }
    
   private func setLoginTextField()  {
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailTextField)
        self.emailTextField.placeholder = " Add your email"
        self.emailTextField.layer.borderWidth = 2
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            emailTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70),
            emailTextField.widthAnchor.constraint(equalToConstant: 240),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
   private func setPasswordTextField()  {
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passwordTextField)
        self.passwordTextField.placeholder = " Enter your password"
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.layer.borderWidth = 2
        
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 240),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
  private  func setLoginButton()  {
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loginButton)
        self.loginButton.setTitle("Login", for: .normal)
        self.loginButton.backgroundColor = .lightGray
        self.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)

        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
   private func setRegistrationButton()  {
        self.registrationButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(registrationButton)
        self.registrationButton.setTitle("Register", for: .normal)
        self.registrationButton.backgroundColor = .lightGray
        self.registrationButton.addTarget(self, action: #selector(registration), for: .touchUpInside)

        NSLayoutConstraint.activate([
            registrationButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            registrationButton.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: 20),
            registrationButton.widthAnchor.constraint(equalToConstant: 100),
            registrationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setSkipLoginButton() {
        self.skipLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(skipLoginButton)
        self.skipLoginButton.setTitle("Skip", for: .normal)
        self.skipLoginButton.backgroundColor = .gray
        self.skipLoginButton.addTarget(self, action: #selector(skipLogin), for: .touchUpInside)

        NSLayoutConstraint.activate([
            skipLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            skipLoginButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            skipLoginButton.widthAnchor.constraint(equalToConstant: 240),
            skipLoginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func login() {
        Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] authResult, error in
            guard self != nil else { return }
          
            if error != nil {
                print("Login error!!! \(error)")
                self?.showErrorAlert(message: error?.localizedDescription ?? "Unknown error")
            }
            if authResult != nil {
                let tabBarController = TabBarController()
                tabBarController.modalPresentationStyle = .overCurrentContext
                self?.present(tabBarController, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func registration(){
        Auth.auth().createUser(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { authResult, error in
            if error != nil {
                print("Registration error!!! \(error)")
                self.showErrorAlert(message: error?.localizedDescription ?? "Unknown error")
            }
            if authResult != nil {
                print("Registered")
            }
            
        }
    }
    
    private func showErrorAlert(message: String)  {
        let alert = UIAlertController(title: "ERROR!!!", message: message, preferredStyle: .alert)
        
        let allertOkButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    
        alert.addAction(allertOkButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func skipLogin()  {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .overCurrentContext
        self.present(tabBarController, animated: true, completion: nil)
    }
}
