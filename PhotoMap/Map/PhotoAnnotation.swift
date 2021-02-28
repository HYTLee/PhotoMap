//
//  PhotoAnnotation.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 2/28/21.
//

import Foundation
import UIKit
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var photo: Photo?
  var text: String?
  let title: String?
  var subtitle: String?
  
  init(coordinate: CLLocationCoordinate2D, text: String, photo: Photo? = nil) {
    self.coordinate = coordinate
    self.text = text
    self.photo = photo
    self.subtitle = photo?.imageDescription
    self.title = "Category"
  }
}
