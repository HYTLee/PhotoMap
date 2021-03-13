//
//  DateFormatter.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/11/21.
//

import Foundation

class DateFormattering {
 
    func convertDateToDMYFormat(_ date: Date) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yy"
            return dateFormatter.string(from: date)
        }
    
    func convertDateToMYFormat(_ date: Date) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-yyyy"
            return dateFormatter.string(from: date)
        }
    
    func converDateForImagePickerPopUp(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy - HH:mm a"
        return dateFormatter.string(from: date)
    }
}
