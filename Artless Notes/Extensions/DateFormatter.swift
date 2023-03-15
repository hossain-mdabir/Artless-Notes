//
//  DateFormatter.swift
//  Artless Notes
//
//  Created by Md Abir Hossain on 25/2/23.
//

import Foundation


// MARK: - Date Formatter
func dateFormatter(date: Date)   -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)  // Calendar type
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let deliveryDate = dateFormatter.string(from: date)
    
    return deliveryDate
}
