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
import FirebaseDatabase

class PopUpWindow: UIViewController {
    
    private let database = Database.database().reference()
    let popUpWindowView = PopUpWindowView()
    let dateFormatter = DateFormattering()
    var currentLocation: CLLocation?
    var imageName: String?
    var keysForFirebase: [String] = []

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
    
    func addNewPhotoRecordToRealm()  {
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
    
    func addNewPhotoToFirebase()  {
        let uuid = UUID().uuidString
                
        let newPhotoRecord: [String: Any] = [
            "imageName": imageName ?? "",
            "imageDescription": popUpWindowView.popupTextView.text ?? "",
            "latitude": currentLocation?.coordinate.latitude ?? 0.0,
            "longitude": currentLocation?.coordinate.longitude ?? 0.0,
            "created": dateFormatter.converDateForFirebase(Date()),
            "category" : popUpWindowView.category.name
        ]
        database.child(uuid).setValue(newPhotoRecord)
    }
}
