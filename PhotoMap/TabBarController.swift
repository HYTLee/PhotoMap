//
//  TabBarController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 2/25/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubviews()
    }
    
    func addSubviews()  {
       viewControllers = [NavigationController(), TimelineViewController(), MoreViewController()]
        tabBar.items?[0].title = "Map"
        tabBar.items?[1].title = "Timeline"
        tabBar.items?[2].title = "More..."
    }


}
