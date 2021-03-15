//
//  LoginNaviggationController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/15/21.
//

import UIKit

class LoginNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubViews()
    }
    
    private func addSubViews()  {
        viewControllers = [LoginViewController()]
    }


}
