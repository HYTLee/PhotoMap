//
//  TimeLinePhoto.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/12/21.
//

import Foundation
import UIKit

class TimeLinePhoto {
    private var dateFormatter = DateFormattering()
    
    let creationMonthAndYear: String
    let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
        self.creationMonthAndYear = dateFormatter.convertDateToMYFormat(photo.created)
    }
    
}
