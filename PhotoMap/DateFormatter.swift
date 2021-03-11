//
//  DateFormatter.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/11/21.
//

import Foundation

class DateFormattering {
 
    func convertDateFormater(_ date: Date) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            return dateFormatter.string(from: date)
        }
}
