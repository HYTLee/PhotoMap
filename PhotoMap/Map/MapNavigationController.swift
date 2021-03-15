//
//  NavigationController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 2/25/21.
//

import UIKit

// Navigation controller for Map view
class MapNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubViews()
    }
    

    private func addSubViews()  {
        viewControllers = [MapViewController()]
    }


}
