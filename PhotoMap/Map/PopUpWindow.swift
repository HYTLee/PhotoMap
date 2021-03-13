//
//  PopUpWindow.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 2/28/21.
//

import Foundation
import UIKit
import RealmSwift
import CoreLocation

class PopUpWindow: UIViewController {
    
    let popUpWindowView = PopUpWindowView()
    var currentLocation: CLLocation?
    var imageName: String?

    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        popUpWindowView.popupImage.image = image

        self.view = popUpWindowView 
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addNewPhotoRecord()  {
        let realm = try! Realm()
        try! realm.write{
            let newPhotoRecord = Photo()
            if popUpWindowView.popupTextView.text != "Enter description for you text" && popUpWindowView.popupTextView.textColor != .lightGray {
                newPhotoRecord.imageDescription = popUpWindowView.popupTextView.text
            }
            // Did this to avoid problem with map annotation without text
            else {
                newPhotoRecord.imageDescription = " "
            }
            newPhotoRecord.category = popUpWindowView.category.name
            newPhotoRecord.latitude = currentLocation?.coordinate.latitude ?? 0.0
            newPhotoRecord.longitude = currentLocation?.coordinate.longitude ?? 0.0
            newPhotoRecord.imageName = imageName ?? ""
            realm.add(newPhotoRecord)
          }
    }
  
}
