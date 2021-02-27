//
//  NavigationController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 2/25/21.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubViews()
    }
    

    func addSubViews()  {
        viewControllers = [MapViewController()]
    }


}
