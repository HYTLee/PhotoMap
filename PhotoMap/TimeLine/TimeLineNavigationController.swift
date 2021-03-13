//
//  TimeLineNavigationController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/12/21.
//

import Foundation
import UIKit

class TimeLineNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubViews()
    }
    

    func addSubViews()  {
        viewControllers = [TimelineViewController()]
    }


}
