//
//  DateFormatter+Extension.swift
//  TofDatAura
//
//  Created by User on 30/06/2022.
//

import Foundation

extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
    
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()
    
    static let frenchDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "FR-fr")
        return formatter
    }()
    
    static func parseTime(time: String?) -> Date? {
        if (time == nil) {
            return nil
        }
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let rsc = RFC3339DateFormatter.date(from: time!)
        return rsc
    }
    
    static func dateToTime(date: Date?) -> String {
        if (date == nil) {
            return String("")
        }
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return outputDateFormatter.string(from: date!)
    }
}
