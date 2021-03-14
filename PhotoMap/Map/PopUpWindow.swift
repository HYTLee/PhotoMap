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

// View Controller for PopUpWindowView
class PopUpWindow: UIViewController {
    
    // MARK: Set variables
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
        addTapGestureToImageView()

        self.view = popUpWindowView 
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set gesture recognizer
    func addTapGestureToImageView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        popUpWindowView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let fullPhotoViewController = FullPhotoViewController()
        fullPhotoViewController.fullPhotoImageView.image = popUpWindowView.popupImage.image
        self.present(fullPhotoViewController, animated: true, completion: nil)
    }
    
    
    // MARK: Working with realm
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
    
    // MARK: Working with firebase
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
        database.child("PhotoKey").child(uuid).setValue(newPhotoRecord)
    }
    
    func getAllFireBaseKeys()  {
        database.child("PhotoKey").observe(.value) { [self] (snapshot) in
            for child in snapshot.children {
                let valueD = child as! DataSnapshot
                keysForFirebase.append(valueD.key)
                print(keysForFirebase)

            }
        }
    }
}
