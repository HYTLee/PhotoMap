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
       viewControllers = [MapNavigationController(), TimeLineNavigationController(), MoreViewController()]
        tabBar.items?[0].title = "Map"
        tabBar.items?[0].image = UIImage(named: "map.png")
        tabBar.items?[1].title = "Timeline"
        tabBar.items?[1].image = UIImage(named: "timeline.png")
        tabBar.items?[2].title = "More"
        tabBar.items?[2].image = UIImage(named: "more.png")

    }


}
