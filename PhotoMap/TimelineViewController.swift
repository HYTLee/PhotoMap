//
//  TimelineViewController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 2/25/21.
//

import UIKit
import RealmSwift


class TimelineViewController: UIViewController {
    
    private let imageLoader = ImageLoader()
    
    let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    var photos = try! Realm().objects(Photo.self)



    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(image)
        image.backgroundColor = .green
        
        image.image = imageLoader.loadImageFromDiskWith(fileName: photos[1].imageName)
        

        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 40),
            image.widthAnchor.constraint(equalToConstant: 140),
            image.topAnchor.constraint(equalTo: self.view.topAnchor),
            image.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
}
