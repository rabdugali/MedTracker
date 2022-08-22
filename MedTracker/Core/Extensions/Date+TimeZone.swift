//
//  Date+TimeZone.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import Foundation

extension Date {
    static var currentTimeZoneInterval: TimeInterval {
        TimeInterval(TimeZone.current.secondsFromGMT())
    }
    
    static func currentDate() -> Date {
        return Calendar.current.startOfDay(for: Date().currentTimeZone()).currentTimeZone()
    }
    
    func currentTimeZone() -> Date {
        return self.addingTimeInterval(Self.currentTimeZoneInterval)
    }
}
