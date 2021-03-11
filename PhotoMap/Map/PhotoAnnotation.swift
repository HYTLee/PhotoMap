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
    
    let dateFormatter = DateFormattering()
    
  var coordinate: CLLocationCoordinate2D
  var photo: Photo?
  var text: String?
  let title: String?
  var subtitle: String?
  
  init(coordinate: CLLocationCoordinate2D, photo: Photo? = nil) {
    self.coordinate = coordinate
    self.text = photo?.category
    self.photo = photo
    self.subtitle = dateFormatter.convertDateFormater(photo!.created)
    self.title = photo?.imageDescription
  }
}
