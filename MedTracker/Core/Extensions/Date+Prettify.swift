//
//  Date+prettyTime.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import Foundation

extension Date {
    func prettyTime() -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func prettyDate() -> String {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter
}()
