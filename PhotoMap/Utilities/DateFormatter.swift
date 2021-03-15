//
//  DateFormatter.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/11/21.
//

import Foundation

// Date formatters used i aplication
class DateFormattering {
 
    func convertDateToDMYFormat(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        return dateFormatter.string(from: date)
    }
    
    func convertDateToMYFormat(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM - yyyy"
        return dateFormatter.string(from: date)
    }
    
    func converDateForImagePickerPopUp(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy - HH:mm a"
        return dateFormatter.string(from: date)
    }
    
    func converDateForFullPhotoScreenFirstPart(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    func converDateForFullPhotoScreenSecondPart(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: date)
    }
    
    func converDateForFirebase(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy - HH:mm a"
        return dateFormatter.string(from: date)
    }

}

