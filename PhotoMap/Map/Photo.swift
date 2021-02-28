//
//  Photo.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 2/27/21.
//

import Foundation
import UIKit
import RealmSwift

class Photo: Object {
  @objc dynamic var imageURL = ""
  @objc dynamic var imageDescription = ""
  @objc dynamic var latitude = 0.0
  @objc dynamic var longitude = 0.0
  @objc dynamic var created = Date()
//  @objc dynamic var category: Category!
}

